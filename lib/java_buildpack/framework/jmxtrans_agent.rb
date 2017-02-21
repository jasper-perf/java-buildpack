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

module JavaBuildpack
  module Framework
    class JmxtransAgent < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Util

      VERSION = '1.2.4'

      URL = 'https://github.com/jmxtrans/jmxtrans-agent/releases/download/' +
            "jmxtrans-agent-#{VERSION}/jmxtrans-agent-#{VERSION}.jar"

      JARNAME = 'jmxtrans-agent.jar'

      PORT_KEY = 'port'
      HOST_KEY = 'host'

      FILTER = /jmxtrans/

      def detect
        VERSION if @application.services.one_service?(FILTER)
        puts Dir.entries("./")
      end

      def compile
        system('printenv')
        download_jar(VERSION, URL, JARNAME)

        path = JavaBuildpack::Component::Droplet.const_get(:RESOURCES_DIRECTORY) +
               @droplet.component_id +
               './jmxtrans-agent.xml.erb'

        port = '2003'
        host = 'localhost'
        if @application.services.one_service?(FILTER, [HOST_KEY, PORT_KEY])
          port = @application.services.find_service(FILTER)['credentials']['port']
          host = @application.services.find_service(FILTER)['credentials']['host']
        end

        data = OpenStruct.new(
          port: port,
          host: host,
         namePrefix: "apps.#{ENV['CF_ORG']}.#{@application.details['space_name']}.#{@application.details['application_name']}.${CF_INSTANCE_INDEX}"
        ).instance_eval { binding }

        content = ERB.new(File.read(path)).result(data)

        File.write(@droplet.sandbox + './jmxtrans-agent.xml', content)
      end

      def release
        @droplet.java_opts.add_preformatted_options("-javaagent:#{qualify_path(@droplet.sandbox + JARNAME, @droplet.root)}=#{qualify_path(@droplet.sandbox + 'jmxtrans-agent.xml', @droplet.root)}")
      end
    end
  end
end
