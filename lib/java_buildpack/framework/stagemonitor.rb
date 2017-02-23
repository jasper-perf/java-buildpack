# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013-2016 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'java_buildpack/component/base_component'
require 'java_buildpack/framework'
require 'erb'
require 'ostruct'
require 'fileutils'

gem "git", "~> 1.3"

module JavaBuildpack
  module Framework
    class Stagemonitor < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Util


      VERSION = '0.31.0'


      URL = 'https://github.com/jmxtrans/jmxtrans-agent/releases/download/' +
            "jmxtrans-agent-#{VERSION}/jmxtrans-agent-#{VERSION}.jar"


      PORT_KEY = 'port'
      HOST_KEY = 'host'

      FILTER = /stagemonitor/

      def detect
        VERSION if @application.services.one_service?(FILTER)
      end

      def compile
        download_dependencies
      end

      def release
        graphite_config = {}
        java_opts = @droplet.java_opts
      end

      private

        URI='https://github.com/felixbarny/stagemonitor-get-all-libs'
        REPO_NAME='stagemonitor_dependencies'
        JAR_URL='https://s3-eu-west-1.amazonaws.com/stagemonitor-integration-assests-public/monitor-0.0.1.jar'
        JARNAME='monitor-0.0.1.jar'


      def download_dependencies
        g = Git.clone(URI, REPO_NAME, :path => './')
        system( "cd #{REPO_NAME}; ./gradlew copyLibs -PstagemonitorVersion=#{VERSION}" )
        in_dir = @droplet.root + "#{REPO_NAME}/build/."
        out_dir = @droplet.root + "lib"
        FileUtils.cp_r in_dir, out_dir
        download_jar(VERSION, JAR_URL, JARNAME)  
        FileUtils.cp_r @droplet.sandbox + JARNAME, out_dir         
      end


      def get_graphite_opts(graphite_config)
        if @application.services.one_service?(FILTER, [HOST_KEY, PORT_KEY])
          graphite_config['graphite.host'] = @application.services.find_service(FILTER)['credentials']['host']
          graphite_config['graphite.port'] = @application.services.find_service(FILTER)['credentials']['port']
        else
          graphite_config['graphite.host'] = "localhost"
          graphite_config['graphite.port'] = "2003"
        end
        graphite_config['graphite.prefix'] = "apps.${CF_ORG}.#{@application.details['space_name']}.#{@application.details['application_name']}.${CF_INSTANCE_INDEX}"
      end

      def write_java_opts(java_opts, grahite_config)
        grahite_config.each do |key, value|
          java_opts.add_system_property(key, value)
        end
      end

    end
  end
end
