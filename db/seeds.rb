# User.invite!({ first_name: "Martin", last_name: "Hladil", email: "martin@3lancers.cz", role: User::Role::ADMIN, support: true})
# User.invite!({ first_name: "Tomas", last_name: "Pavelka", email: "tomas@3lancers.cz", role: User::Role::ADMIN, support: true})
# User.invite!({ first_name: "Robert", last_name: "Cigan", email: "robert@3lancers.cz", role: User::Role::ADMIN, support: true})
# User.invite!({ first_name: "Chris", last_name: "Ronzio", email: "cronzio@gmail.com", role: User::Role::ADMIN, support: true})

# User.invite!({ first_name: "Zach", last_name: "Stradling", email: "zach@organizechaos.com", role: User::Role::ADMIN, support: true})

Setting.create(:contract_type=>"General", :intro=>"this is the intro", :terms_and_conditions_list=>["terms and conditions", "more terms and conditions"], :systematic_price_reductions=>"sys price reduction", :optional_extension=>"optional_extension", :end_of_agreement=>"end_of_agreement", :note=>"note", :payment_to_consignor=>"payemnt to consignor", :insurance=>"insurance", :additional_notes=>"additional_notes", :experation_date=>"experation_date")
