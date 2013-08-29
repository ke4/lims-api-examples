require 'sequel'
require 'lims-laboratory-app'
require 'lims-core/persistence/sequel'
require 'optparse'
require 'yaml'

require 'rubygems'
require 'ruby-debug'

# Setup the arguments passed to the script
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: tube_rack_seeding.rb [options]"
  opts.on("-d", "--db [DB]") { |v| options[:db] = v }
end.parse!

CONNECTION_STRING = options[:db] || "sqlite:///Users/ke4/projects/lims-laboratory-app/dev.db"
DB = Sequel.connect(CONNECTION_STRING)
STORE = Lims::Core::Persistence::Sequel::Store.new(DB)
config = YAML.load_file(File.join('config','seed_parameters.yml'))
NUMBER_OF_TUBES = config["number_of_tubes"]

# Needed for the order creation
# - a valid study uuid
# - a valid user uuid
order_config = STORE.with_session do |session|
  user = Lims::LaboratoryApp::Organization::User.new
  session << user
  user_uuid = session.uuid_for!(user)

  study = Lims::LaboratoryApp::Organization::Study.new
  session << study
  study_uuid = session.uuid_for!(study)

  lambda { {:user_id => session.id_for(user), 
            :user_uuid => user_uuid,
            :study_id => session.id_for(study),
            :study_uuid => study_uuid} }
end.call

# define a pipeline
pipeline =
  {:name          => "manual DNA only",
   :kit_type      => "DNA",
   :initial_type  => "DNA+P",
   :initial_role  => "samples.extraction.manual.dna_only.input_tube_dnap"
  }

ean13_barcodes = Object.new.tap do |o|
  class << o
    attr_accessor :last_barcode
  end
  o.last_barcode = 8800000000000

  def o.pop
    self.last_barcode += 1
    self.last_barcode.to_s
  end
end


sanger_barcodes = Object.new.tap do |o|
  class << o
    attr_accessor :last_barcode
  end
  o.last_barcode = 8800000

  def o.pop
    self.last_barcode += 1
    "JD#{self.last_barcode}L"
  end
end

# create labelled tubes
labelled_tubes = []
NUMBER_OF_TUBES.times do |i|
  STORE.with_session do |session|
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    session << tube
    tube_uuid = session.uuid_for!(tube)

    barcode_value = ean13_barcodes.pop 
    sanger_barcode_value = sanger_barcodes.pop
    labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => tube_uuid, :type => "resource")
    labellable["barcode"] = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "ean13-barcode", :value => barcode_value)
    labellable["sanger label"] = Lims::LaboratoryApp::Labels::Labellable::Label.new(:type => "sanger-barcode", :value => sanger_barcode_value)

    session << labellable
    session.uuid_for!(labellable)

    labelled_tubes << tube
  end
end

# creates a tube rack
rack_position = []
('A'..'H').each do |row|
  ('1'..'12').each do |col|
    rack_position << row + col
  end
end

tube_rack_uuid = STORE.with_session do |session|
  tube_rack = Lims::LaboratoryApp::Laboratory::TubeRack.new(
    :number_of_columns => 12,
    :number_of_rows => 8)

  rack_position.zip(labelled_tubes) do |position, tube|
    tube_rack[position] = tube
  end

  session << tube_rack
  tube_rack_uuid = session.uuid_for!(tube_rack)
  lambda { tube_rack_uuid }
end.call

# adds the tube rack to an order
STORE.with_session do |session|
  order = Lims::LaboratoryApp::Organization::Order.new(
    :creator => session.user[order_config[:user_id]],
    :study => session.study[order_config[:study_id]],
    :pipeline => pipeline[:name],
    :cost_code => "cost code")
  order.add_source(pipeline[:initial_role], [tube_rack_uuid])

  session << order
  session.uuid_for!(order)
end
