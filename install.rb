# Install hook code here

HOBO_JQGRID_HOME = File.dirname(__FILE__)

FileUtils.cp "#{HOBO_JQGRID_HOME}/public/javascripts/prototype.js", "#{RAILS_ROOT}/public/javascripts/prototype.js"
FileUtils.mkpath "#{RAILS_ROOT}/public/js"
FileUtils.cp_r "#{HOBO_JQGRID_HOME}/public/js/.", "#{RAILS_ROOT}/public/js/"
FileUtils.mkpath "#{RAILS_ROOT}/public/themes"
FileUtils.cp_r "#{HOBO_JQGRID_HOME}/public/themes/.", "#{RAILS_ROOT}/public/themes/"

