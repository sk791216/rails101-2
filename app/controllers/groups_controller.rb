class GroupsController < ApplicationController
  def index
    @group = Group.all
  end
end
