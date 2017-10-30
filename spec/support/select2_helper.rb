module Select2Helper
  def select2(value, **options)
    first("##{options[:from]}+.select2-container").click
    page.within("body>.select2-container") do
      find(".select2-search__field").set(value)
      expect(page).to have_content(value)
      first(".select2-results__option", text: value).click
    end
  end
  
  def select2tag(value, **options)
    expect(page).to have_css("##{options[:from]}+.select2-container")
    first("##{options[:from]}+.select2-container").click
    page.within(first("##{options[:from]}[multiple]") ? "##{options[:from]}+.select2-container" : "body>.select2-container") do
      find(".select2-search__field").set(value)
    end
    page.within("body>.select2-container") do
      expect(page).to have_content(value)
      first(".select2-results__option", text: value).click
    end
  end
end

RSpec.configure do |config|
  config.include Select2Helper, type: :feature
end