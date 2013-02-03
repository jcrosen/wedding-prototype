require 'spec_helper'

describe GuestsController do

  let(:invitation) { Factory.create(:invitation) }
  let(:user) { login_user }
  let(:owner) { Factory.create(:guest, role: 'owner', invitation_id: invitation.id, user_id: user.id) }
  let(:viewer) { Factory.create(:guest, role: 'viewer', invitation_id: invitation.id, user_id: user.id) }

  def create_guests(size, atts = {})
    guests = []
    size.times { guests << Factory.create(:guest, atts || {}) }
    guests
  end

  context "Invitation owner is logged in " do
    describe "#index" do
      before do
        owner
        create_guests(5, invitation_id: owner.invitation_id)
        get :index, invitation_id: owner.invitation_id
      end

      it { should respond_with :success }
      it { should assign_to :guests }
    end

    describe "#create" do
      before do
        owner
        @atts = Factory.build(:guest, invitation_id: owner.invitation_id, role: 'viewer').attributes
        @atts.delete("id"); @atts.delete("created_at"); @atts.delete("updated_at");
      end

      context "Submitting valid attributes " do
        context "via HTML" do
          before do
            post :create, format: :html, invitation_id: owner.invitation_id, guest: @atts
          end

          it { should redirect_to invitation_path(owner.invitation) }
          it { should assign_to :guest }
          it { should set_the_flash[:notice] }
        end
        context "via JSON" do
          before do
            post :create, format: :json, invitation_id: owner.invitation_id, guest: @atts
          end

          it { should respond_with_content_type(:json) }
          it { should respond_with :success }

          it "returns a guest node" do
            expect(JSON.parse(response.body)).to include "guest"
          end
        end
      end

      context "Submitting malformed attributes " do
        before do
          @bad_atts = {}
          @atts.each { |k,v| @bad_atts.merge!(k => (k == "invitation_id" ? v : "")) }  # keep the invitation id or we'll get a permission error redirect instead of an :unprocessable_entity
        end

        context "via HTML" do
          before do
            post :create, format: :html, invitation_id: owner.invitation_id, guest: @bad_atts
          end

          it { should respond_with :unprocessable_entity }
          it { should render_template :new }
          it { should assign_to :guest }
          it { should set_the_flash[:alert] }
        end
        context "via JSON" do
          before do
            post :create, format: :json, invitation_id: owner.invitation_id, guest: @bad_atts
          end

          it { should respond_with_content_type(:json) }
          it { should respond_with :unprocessable_entity }

          it "returns a guest node" do
            expect(JSON.parse(response.body)).to include "guest"
          end
          it "returns an errors node" do
            expect(JSON.parse(response.body)).to include "errors"
          end
        end
      end
    end

    describe "#new" do
      before do
        owner
        get :new, invitation_id: owner.invitation_id
      end

      it { should respond_with :success }
      it { should assign_to :guest }
    end

    describe "#update" do
      before do
        owner
        @guest = Factory.create(:guest, invitation_id: owner.invitation_id)
        @atts = {first_name: 'test_me_first', last_name: 'test_me_last', display_name: 'test_me_... display?', role: 'owner'}
        put :update, invitation_id: owner.invitation_id, id: @guest.id, guest: @atts
      end

      context "Submitting valid attributes" do
        context "via HTML" do
          before do
            put :update, format: :html, invitation_id: owner.invitation_id, id: @guest.id, guest: @atts
          end

          it { should redirect_to invitation_path(@guest.invitation) }
          it { should assign_to :guest }
          it { should set_the_flash[:notice] }

          it "updates the guest" do
            @guest.reload
            expect(@guest.first_name).to eq(@atts[:first_name])
            expect(@guest.last_name).to eq(@atts[:last_name])
            expect(@guest.display_name).to eq(@atts[:display_name])
            expect(@guest.role).to eq(@atts[:role])
          end
        end

        context "via JSON" do
          before do
            put :update, format: :json, invitation_id: owner.invitation_id, id: @guest.id, guest: @atts
          end

          it { should respond_with_content_type(:json) }
          it { should respond_with :success }

          it "returns a guest node" do
            expect(JSON.parse(response.body)).to include "guest"
          end

          it "updates the guest" do
            @guest.reload
            expect(@guest.first_name).to eq(@atts[:first_name])
            expect(@guest.last_name).to eq(@atts[:last_name])
            expect(@guest.display_name).to eq(@atts[:display_name])
            expect(@guest.role).to eq(@atts[:role])
          end
        end
      end

      context "Submitting malformed attributes" do
        before do
          @bad_atts = @atts.clone
          @bad_atts["role"] = ""
          @bad_atts["display_name"] = ""
        end

        context "via HTML" do
          before do
            put :update, format: :html, invitation_id: owner.invitation_id, id: @guest.id, guest: @bad_atts
          end

          it { should respond_with :unprocessable_entity }
          it { should render_template :edit }
          it { should assign_to :guest }
          it { should set_the_flash[:alert] }

          it "does not update the guest" do
            @guest.reload
            expect(@guest.first_name).to eq(@atts[:first_name])
            expect(@guest.last_name).to eq(@atts[:last_name])
            expect(@guest.display_name).to eq(@atts[:display_name])
            expect(@guest.role).to eq(@atts[:role])
          end
        end

        context "via JSON" do
          before do
            put :update, format: :json, invitation_id: owner.invitation_id, id: @guest.id, guest: @bad_atts
          end

          it { should respond_with_content_type(:json) }
          it { should respond_with :unprocessable_entity }

          it "returns a guest node" do
            expect(JSON.parse(response.body)).to include "guest"
          end
          it "returns an errors node" do
            expect(JSON.parse(response.body)).to include "errors"
          end

          it "does not update the guest" do
            @guest.reload
            expect(@guest.first_name).to eq(@atts[:first_name])
            expect(@guest.last_name).to eq(@atts[:last_name])
            expect(@guest.display_name).to eq(@atts[:display_name])
            expect(@guest.role).to eq(@atts[:role])
          end
        end
      end
    end

    describe "#destroy" do
      before do
        owner
        @guest = Factory.create(:guest, invitation_id: owner.invitation_id)
      end

      context "via HTML" do
        before do
          delete :destroy, format: :html, invitation_id: owner.invitation_id, id: @guest.id
        end

        it { should redirect_to invitation_path(owner.invitation) }
        it { should assign_to :guest }
        it { should set_the_flash[:notice] }

        it "should delete the guest" do #TODO: is this necessary or overstepping the bounds of this testing scenario?
          expect(Guest.find_by_id(@guest.id)).to_not be
        end
      end

      context "via JSON" do
        before do
          delete :destroy, format: :json, invitation_id: owner.invitation_id, id: @guest.id
        end

        it { should respond_with_content_type(:json) }
        it { should respond_with :success }

        it "returns a guest node" do
          expect(JSON.parse(response.body)).to include "guest"
        end
      end
    end

    describe "#edit" do
      before do
        owner
      end

      context "via HTML" do
        before do
          get :edit, format: :html, invitation_id: owner.invitation_id, id: owner.id
        end

        it { should respond_with :success }
        it { should assign_to :guest }
      end

      context "via JSON" do
        before do
          get :edit, format: :json, invitation_id: owner.invitation_id, id: owner.id
        end

        it { should respond_with_content_type(:json) }
        it { should respond_with :success }

        it "returns a guest node" do
          expect(JSON.parse(response.body)).to include "guest"
        end
      end
    end

    describe "#show" do
      before do
        owner
      end

      context "via HTML" do
        before do
          get :show, format: :html, invitation_id: owner.invitation_id, id: owner.id
        end

        it { should respond_with :success }
        it { should assign_to :guest }
      end

      context "via JSON" do
        before do
          get :show, format: :json, invitation_id: owner.invitation_id, id: owner.id
        end

        it { should respond_with_content_type(:json) }
        it { should respond_with :success }

        it "returns a guest node" do
          expect(JSON.parse(response.body)).to include "guest"
        end
      end
    end

  end

context "Invitation viewer is logged in" do

end

end
