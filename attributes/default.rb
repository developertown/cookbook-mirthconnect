default[:mirthconnect][:version]       = "3.0.1.7051.b1075"
default[:mirthconnect][:download_file] = "mirthconnect-#{default[:mirthconnect][:version]}-unix.tar.gz"
default[:mirthconnect][:download_url]  = "http://downloads.mirthcorp.com/connect/#{default[:mirthconnect][:version]}/#{default[:mirthconnect][:download_file]}"

node[:mirthconnect][:homedir] = "/opt/mirth"
node[:mirthconnect][:user] = "mirth"
node[:mirthconnect][:group] = "mirth"