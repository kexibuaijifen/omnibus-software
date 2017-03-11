name "datadog-metro"
default_version "last-stable"

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-metro"
}

dependency "libpcap"

#TODO: complete OSX support.
if ohai['platform_family'] == 'mac_os_x'
  env.delete "GOROOT"
  gobin = "/usr/local/bin/go"
else
  gobin = "/usr/local/go/bin/go"
end

build do

  build_env = {
    "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}",
    "LDFLAGS" => "/opt/paas-agent/embedded/lib/libpcap.a",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "CFLAGS" => "-I/opt/paas-agent/embedded/include"
	}



   
   ship_license "https://raw.githubusercontent.com/DataDog/go-metro/master/LICENSE"
   ship_license "https://raw.githubusercontent.com/DataDog/go-metro/master/THIRD_PARTY_LICENSES.md"
   command "mkdir -p /var/cache/omnibus/src/datadog-metro/src/github.com/DataDog", :env => env
   command "#{gobin} get -v -d github.com/DataDog/go-metro", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
   command "git checkout #{default_version} && git pull", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro/src/github.com/DataDog/go-metro"
   command "#{gobin} get -v -d github.com/cihub/seelog", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
   command "#{gobin} get -v -d github.com/google/gopacket", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
   command "#{gobin} get -v -d github.com/DataDog/datadog-go/statsd", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
   command "#{gobin} get -v -d gopkg.in/tomb.v2", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
   command "#{gobin} get -v -d gopkg.in/yaml.v2", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
   #patch :source => "libpcap-static-link.patch", :plevel => 1,
         #:acceptable_output => "Reversed (or previously applied) patch detected",
         #:target => "/var/cache/omnibus/src/datadog-metro/src/github.com/google/gopacket/pcap/pcap.go"
   command "#{gobin} build -o #{install_dir}/bin/go-metro github.com/DataDog/go-metro", :env => env, :cwd => "/var/cache/omnibus/src/datadog-metro"
end
