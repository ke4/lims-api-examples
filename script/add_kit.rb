require 'sequel'
require 'lims-laboratory-app'
require 'lims-support-app/kit/kit'
require 'lims-support-app/kit/kit_persistor'
require 'lims-support-app/kit/kit_sequel_persistor'
require 'lims-core/persistence/sequel'
require 'lims-core/persistence/sequel/filters'
require 'optparse'
require 'rubygems'
require 'ruby-debug'

# Setup the arguments passed to the script
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: add_kit.rb [options]"
  opts.on("-d", "--db [DB]") { |v| options[:db] = v }
  opts.on("-v", "--verbose") { |v| options[:verbose] = true }
  opts.on("-pn", "--process_name P") { |pn| options[:process_name] = pn }
  opts.on("-at", "--aliquot_type AT") { |at| options[:aliquot_type] = at }
  opts.on("-ed", "--expiry_date ED") { |ed| options[:expiry_date] = ed }
  opts.on("-am", "--amount AM") { |am| options[:amount] = am }
  opts.on("-lt", "--label_type LT") { |lt| options[:label_type] = lt }
  opts.on("-p", "--position LP") { |lp| options[:position] = lp }
  opts.on("-lv", "--label_value LV") { |lv| options[:label_value] = lv }
end.parse!

CONNECTION_STRING = options[:db] || "sqlite:///Users/ke4/projects/lims-support-app/test.db"
DB = Sequel.connect(CONNECTION_STRING)
STORE = Lims::Core::Persistence::Sequel::Store.new(DB)

STORE.with_session do |session|
  kit = Lims::SupportApp::Kit.new(
    :process      => options[:process_name],
    :aliquot_type => options[:aliquot_type],
    :expires      => options[:expiry_date],
    :amount       => options[:amount]
  )
  session << kit
  kit_uuid = session.uuid_for!(kit)

  labellable = Lims::LaboratoryApp::Labels::Labellable.new(
    :type => "resource",
    :name => kit_uuid)
  labellable[options[:position]] = Lims::LaboratoryApp::Labels::Labellable::Label.new(
    :type => options[:label_type],
    :value => options[:label_value])
end
