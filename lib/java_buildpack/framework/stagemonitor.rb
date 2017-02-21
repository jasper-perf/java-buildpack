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
require 'git'

module JavaBuildpack
  module Framework
    class StageMonitor < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Util

      VERSION = '1.2.4'

      URL = 'https://github.com/jmxtrans/jmxtrans-agent/releases/download/' +
            "jmxtrans-agent-#{VERSION}/jmxtrans-agent-#{VERSION}.jar"

      JARNAME = 'jmxtrans-agent.jar'

      PORT_KEY = 'port'
      HOST_KEY = 'host'

      FILTER = /stagemonitor/

      def detect
        VERSION if @application.services.one_service?(FILTER)
      end

      def compile

        download_dependencies

        download_jar(VERSION, URL, JARNAME)
        @droplet.copy_resources
      end

      def release
        graphite_config = {}
        java_opts = @droplet.java_opts
        get_graphite_opts(graphite_config)
        write_java_opts(java_opts, graphite_config)
        @droplet.java_opts.add_preformatted_options("-javaagent:#{qualify_path(@droplet.sandbox + JARNAME, @droplet.root)}=#{qualify_path(@droplet.sandbox + 'jmxtrans-agent.xml', @droplet.root)}")
      end

      private
      def download_dependencies
        URI='https://github.com/felixbarny/stagemonitor-get-all-libs'
        NAME='stagemonitor_dependencies'
        VERSION = '0.31.0'
        g = Git.clone(URI, NAME, :path => './')
        system( "cd stagemonitor_dependencies; ./gradlew copyLibs -PstagemonitorVersion=#{VERSION}" )
      end


      def add_libraries

         @droplet.additional_libraries 

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
