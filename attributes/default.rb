default[:mirthconnect][:version]       = "3.0.1.7051.b1075"
default[:mirthconnect][:download_file] = "mirthconnect-#{default[:mirthconnect][:version]}-unix.tar.gz"
default[:mirthconnect][:download_url]  = "http://downloads.mirthcorp.com/connect/#{default[:mirthconnect][:version]}/#{default[:mirthconnect][:download_file]}"

default[:mirthconnect][:homedir] = "/opt/mirth"
default[:mirthconnect][:user] = "mirth"
default[:mirthconnect][:group] = "mirth"