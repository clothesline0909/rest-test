require 'spec_helper'

RSpec.describe Project, type: :model do
	before :each do
		@project = Project.new(name: "First Project")
	end

	it "should be valid" do
		expect(@project.valid?).to be true
	end
	
	it "should not accept blank names" do
		@project.name = ""
		expect(@project.valid?).to be false
	end

	it "should not accept names that already exist" do
		@project.save
		@project = Project.new(name: "First Project")
		expect(@project.valid?).to be false
	end

	it "should not accept names that already exist regardless of case" do
		@project.save
		@project = Project.new(name: "FIRST PROJECT")
		expect(@project.valid?).to be false
	end

	it "should accept names three or more characters long" do
		@project.name = "Fir"
		expect(@project.valid?).to be true
	end

	it "should not accept names less then three characters long" do
		@project.name = "Fi"
		expect(@project.valid?).to be false
	end

	it "should accept names fifty or less characters long" do
		@project.name = "F" * 50
		expect(@project.valid?).to be true
	end

	it "should not accept names more than fifty characters long" do
		@project.name = "F" * 51
		expect(@project.valid?).to be false
	end

	it "should save names in lower case" do
		@project.save
		project = Project.last
		expect(project.name).to eq("first project")
	end
end