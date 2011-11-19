execute "portage_sync" do
  user "root"
  command "emerge --sync"
end
