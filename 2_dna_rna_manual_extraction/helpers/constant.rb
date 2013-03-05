module Lims::Api::Examples
  module Constant
    INITIAL_QUANTITY = 1000

    ALIQUOT_TYPE_RNAP = "RNA+P"
    ALIQUOT_TYPE_DNA = "DNA"
    ALIQUOT_TYPE_RNA = "RNA"
    ALIQUOT_TYPE_NA = "NA"
    ALIQUOT_TYPE_NAP = "NA+P"

    BARCODE_EAN13 = "ean13-barcode"
    BARCODE_2D = "2d-barcode"

    ROLE_TUBE_TO_BE_EXTRACTED = "tube_to_be_extracted"

    module DnaRnaManualExtraction
      ORDER_PIPELINE = "DNA+RNA manual extraction"
      
      SOURCE_TUBE_BARCODES = ["XX111111K", "XX222222K", "XX333333K"]
      
      SOURCE_TUBE_ALIQUOT_TYPE = ALIQUOT_TYPE_NAP

      ROLE_BY_PRODUCT_TUBE = "by_product_tube"
      ROLE_BINDING_SPIN_COLUMN_DNA = "binding_spin_column_dna"
      ROLE_ELUTION_SPIN_COLUMN_DNA = "elution_spin_column_dna"
      ROLE_BINDING_SPIN_COLUMN_RNA = "binding_spin_column_rna"
      ROLE_ELUTION_SPIN_COLUMN_RNA = "elution_spin_column_rna"
      ROLE_EXTRACTED_TUBE = "extracted_tube"
      ROLE_EXTRACTED_TUBE_DNA = ROLE_EXTRACTED_TUBE 
      ROLE_EXTRACTED_TUBE_RNA = ROLE_EXTRACTED_TUBE
      ROLE_NAME = "name"
      ROLE_STOCK_RNA = "Stock RNA"
      ROLE_STOCK_DNA = "Stock DNA"
    end

    module DnaRnaAutomatedExtraction
      ORDER_PIPELINE = "DNA+RNA automated extraction"
      SOURCE_TUBE_BARCODE = "XX987654K"
      SOURCE_TUBE_ALIQUOT_TYPE = ALIQUOT_TYPE_NA
      ROLE_ALIQUOT_A = "aliquot_a"
      ROLE_EPPENDORF_A = "eppendorf_a"
      ROLE_ALIQUOT_B = "aliquot_b"
      ROLE_EPPENDORF_B = "eppendorf_b"
      ROLE_ALIQUOT_C = "aliquot_c"
      ROLE_NAME = "name"
      ROLE_EXTRACTED_TUBE_DNA = ROLE_EPPENDORF_A
      ROLE_EXTRACTED_TUBE_RNA = ROLE_EPPENDORF_B
      ROLE_STOCK_RNA = "Stock RNA"
      ROLE_STOCK_DNA = "Stock DNA"
    end
  end
end