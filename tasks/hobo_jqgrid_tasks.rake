# desc "Explaining what the task does"
# task :hobo_jqgrid do
#   # Task goes here
# end

namespace :hobo_jqgrid do
  desc "Install hobo-jqGrid"
  task :install => :environment do

    HOBO_JQGRID_HOME = File.dirname(__FILE__)+"/.."    
    FileUtils.cp "#{HOBO_JQGRID_HOME}/public/javascripts/prototype.js", "#{RAILS_ROOT}/public/javascripts/prototype.js"
    FileUtils.mkpath "#{RAILS_ROOT}/public/js"
    FileUtils.cp_r "#{HOBO_JQGRID_HOME}/public/js/.", "#{RAILS_ROOT}/public/js/"
    FileUtils.mkpath "#{RAILS_ROOT}/public/themes"
    FileUtils.cp_r "#{HOBO_JQGRID_HOME}/public/themes/.", "#{RAILS_ROOT}/public/themes/"
    
  end
 
end
