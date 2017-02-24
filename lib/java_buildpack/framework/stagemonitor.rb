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
require 'java_buildpack/util/spring_boot_utils'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require "open-uri"
require "cgi"
require 'rexml/document'
require 'net/http'


module JavaBuildpack
  module Framework
    class Stagemonitor < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Util


      VERSION = '0.31.0'
      FILTER = 'stagemonitor'

      def detect
        VERSION if @application.services.one_service?(FILTER)
      end

      def compile
        download_dependencies 
      end

      def release
        stagemonitor_config = {}
        java_opts = @droplet.java_opts
        write_opts(java_opts)
        java_opts.add_javaagent(@droplet.root + 'WEB-INF/lib/byte-buddy-agent-1.5.7.jar')
      end


      private

      COMMON_DEPENDNCIES_URL = 'https://stagemonitor-integration-assests-public.s3.amazonaws.com'
      SPRING_BOOT_DEPENDENCIES_REPO = 'https://github.com/andrey-bushik/stagemonitor-spring-boot-integration/releases/download'
      SPRING_BOOT_AGENT_VERSION = '0.1.0'

      def download_dependencies

          if spring_boot?
              lib_path = spring_boot_lib_path
              download_common_dependencies(lib_path)
              download_spring_boot_dependencies(lib_path)
          elsif tomcat?
              lib_path = @droplet.root + 'WEB-INF/lib'
              download_common_dependencies(lib_path)
          end
      end   
     
      def download_common_dependencies(lib_path) 

        if COMMON_DEPENDNCIES_URL.include? "s3.amazonaws.com" 

            xml_data = Net::HTTP.get_response(URI.parse(COMMON_DEPENDNCIES_URL)).body
            doc = REXML::Document.new(xml_data)

            doc.elements.each('/ListBucketResult/Contents/Key/') do |element|
               jar_name = element.text
               jar_url = "https://s3-eu-west-1.amazonaws.com/stagemonitor-integration-assests-public/" + jar_name
               download_jar(VERSION, jar_url, jar_name)
               FileUtils.cp_r @droplet.sandbox + jar_name, lib_path
            end 
        end 
      end

      def download_spring_boot_dependencies(lib_path)

         spring_boot_version_tag = spring_boot_version.gsub(/\.[0-9]+\.[A-Z]+/, 'x') 
         jar_name = "stagemonitor-spring-boot-#{spring_boot_version_tag}-#{SPRING_BOOT_AGENT_VERSION}.jar"
         jar_url = "#{SPRING_BOOT_DEPENDENCIES_REPO}/#{SPRING_BOOT_AGENT_VERSION}/#{jar_name}"
         download_jar(VERSION, jar_url, jar_name)
         FileUtils.cp_r @droplet.sandbox + jar_name, lib_path

      end

      def write_opts(java_opts)
          credentials = @application.services.find_service(FILTER)['credentials']
          credentials.each do |key, value|
            java_opts.add_system_property(key, value)
          end
      end

      # helpers

      def spring_boot?
        JavaBuildpack::Util::SpringBootUtils.new.is?(@application)
      end

      def tomcat?
        war? && !spring_boot? 
      end

      def spring_boot_version
        JavaBuildpack::Util::SpringBootUtils.new.version(@application) 
      end

      def war?
        (@droplet.root + 'WEB-INF/lib').exist?
      end
      
      def spring_boot_lib_path
        JavaBuildpack::Util::SpringBootUtils.new.lib(@droplet)
      end

    end
  end
end
