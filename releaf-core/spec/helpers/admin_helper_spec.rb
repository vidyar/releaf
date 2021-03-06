require 'spec_helper'

describe Releaf::AdminHelper do

  describe "#current_admin_user" do
    login_as_user :user
    it "returns current user" do
      expect( helper.current_admin_user ).to eq(Releaf::Permissions::User.last)
    end
  end

  describe "#get_releaf_menu_item" do
    before do
       @input = {:controller=>"releaf/content", :url_helper=>"releaf_content_nodes_path", :name => "releaf/content/nodes", :icon => "cog"}
       @output = {:icon=>"cog", :name=>"releaf/content/nodes", :url=>"/admin/nodes", :active=>false}
    end

    it "returns menu hash for content controller hash" do
      expect( helper.get_releaf_menu_item(@input) ).to eq(@output)
    end

    context "when controller in params is same as given" do
      it "returns menu hash with :active value set to true" do
        @output[:active] = true
        helper.params[:controller] = "releaf/content"
        expect( helper.get_releaf_menu_item(@input) ).to eq(@output)
      end
    end
  end

  describe "#admin_menu" do
    context "when authorized as :user" do
      login_as_user :user
      it "returns all available controllers in menu" do
        output = [
          {:icon=>"sitemap", :name=>"releaf/content/nodes", :url=>"/admin/nodes", :active=>false},
          {:name=>"inventory", :icon=>"briefcase", :collapsed=>false, :active=>false, :url=>"/admin/books",
           :items=>[
             {:icon=>nil, :name=>"admin/books", :url=>"/admin/books", :active=>false},
             {:icon=>nil, :name=>"admin/authors", :url=>"/admin/authors", :active=>false}]},
          {:name=>"permissions", :icon=>"user", :collapsed=>false, :active=>false, :url=>"/admin/users",
           :items=>[
             {:icon=>nil, :name=>"releaf/permissions/users", :url=>"/admin/users", :active=>false},
             {:icon=>nil, :name=>"releaf/permissions/roles", :url=>"/admin/roles", :active=>false}]},
          {:icon=>"cog", :name=>"releaf/core/settings",:url=>"/admin/settings", :active=>false},
          {:icon=>"group", :name=>"releaf/i18n_database/translations", :url=>"/admin/translations", :active=>false}]
        expect( helper.admin_menu ).to eq(output)
      end
    end

    context "when authorized as :content_user" do
      login_as_user :content_user
      it "returns only content controller in menu" do
        output = [{:icon=>"sitemap", :name=>"releaf/content/nodes", :url=>"/admin/nodes", :active=>false}]
        expect( helper.admin_menu ).to eq(output)
      end
    end
  end
end
