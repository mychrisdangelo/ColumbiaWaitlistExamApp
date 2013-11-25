require 'spec_helper'

describe Professor::CoursesController do
  before(:each) do
    user.confirm!
    sign_in user
  end

  let(:course_json) { 
    '{
    "status_code": 200,
    "data": [
        {
            "DepartmentCode": "COMS",
            "Sections": [
                {
                    "Course": "CBMF4761",
                    "Term": "20131",
                    "TypeName": "LECTURE",
                    "NumEnrolled": 14,
                    "Room2": null,
                    "Room1": "1127",
                    "EndTime2": "None",
                    "MeetsOn2": null,
                    "CampusName": "MORNINGSIDE",
                    "EndTime1": "17:25:00",
                    "Building1": "SEELEY W. MU",
                    "Instructor1Name": "PE\'ER, ITSHACK",
                    "MaxSize": 75,
                    "Building2": null,
                    "CampusCode": "MORN",
                    "CallNumber": 69280,
                    "MeetsOn1": "MW",
                    "SectionFull": "CBMF4761W001",
                    "StartTime1": "16:10:00",
                    "StartTime2": "None"
                }
            ],
            "MaxUnits": 0,
            "Course": "CBMF4761",
            "CourseSubtitle": "COMPUTATIONAL GENOMICS",
            "MinUnits": 0,
            "Description": "Provides comprehensive introduction to computational techniques for analyzing genomic data including DNA, RNA and protein structures; microarrays; transcription and regulation; regulatory, metabolic and protein interaction networks. The course covers sequence analysis algorithms, dynamic programming, hidden Markov models, phylogenetic analysis, Bayesian network techniques, neural networks, clustering algorithms, support vector machines, Boolean models of regulatory networks, flux based analysis of metabolic networks and scale-free network models. The course provides self-contained introduction to relevant biological mechanisms and methods.",
            "NumFixedUnits": 30,
            "DepartmentName": "COMPUTER SCIENCE",
            "SchoolName": "INTERFACULTY",
            "CourseTitle": "COMPUTATIONAL GENOMICS",
            "Approval": ""
        }
    ],
    "status_txt": "OK"
    }'
  }
  let(:section_json) {
    "{
        \"status_code\": 200,
        \"data\": [
          {
        \"Term\": \"20131\",
        \"CampusName\": \"BARNARD COLLEGE\",
        \"StartTime2\": \"None\",
        \"StartTime1\": \"13:10:00\",
        \"Course\": \"SPAN1102\",
        \"CampusCode\": \"CBAR\",
        \"Instructor1Name\": \"ARCE-FERNANDEZ, MARIA I\",
        \"Building1\": \"MILBANK HALL\",
        \"Building2\": null,
        \"NumEnrolled\": 16,
        \"CallNumber\": 511,
        \"MeetsOn1\": \"MTWR\",
        \"SectionFull\": \"SPAN1102W013\",
        \"EndTime1\": \"14:15:00\",
        \"EndTime2\": \"None\",
        \"MeetsOn2\": null,
        \"TypeName\": \"LANGUAGE\",
        \"MaxSize\": 15,
        \"Room2\": null,
        \"Room1\": \"237\"
        }
        ],
          \"status_txt\": \"OK\"
      }"
  }


  context "with a dummy professor" do
    let(:user) { FactoryGirl.build(:professor, :firstname => "Jason", :lastname => "Nieh") }


    context "when no courses are in the Courses API" do
      it "should return no results" do
        user.firstname.should eq("Jason")
        get :index
        expect(assigns(:courses)).to be_empty
      end
    end

    context "when one course has been loaded from the Courses API" do
      it "should render that course without a problem" do
        allow(subject).to receive(:open).and_return subject
        allow(subject).to receive(:read).and_return(section_json, course_json)
        get :index
        expect(assigns(:courses).first.course_title).to eq("COMPUTATIONAL GENOMICS")
      end
    end

    it "should return all courses when there are 500 of them" do
      sections = '{
        "status_code": 200,
        "data": ['

        500.times do |i|
          course_string = "{
        \"Term\": \"20131\",
        \"CampusName\": \"BARNARD COLLEGE\",
        \"StartTime2\": \"None\",
        \"StartTime1\": \"13:10:00\",
        \"Course\": \"SPAN1102\",
        \"CampusCode\": \"CBAR\",
        \"Instructor1Name\": \"ARCE-FERNANDEZ, MARIA I\",
        \"Building1\": \"MILBANK HALL\",
        \"Building2\": null,
        \"NumEnrolled\": 16,
        \"CallNumber\": #{i},
        \"MeetsOn1\": \"MTWR\",
        \"SectionFull\": \"SPAN1102W013\",
        \"EndTime1\": \"14:15:00\",
        \"EndTime2\": \"None\",
        \"MeetsOn2\": null,
        \"TypeName\": \"LANGUAGE\",
        \"MaxSize\": 15,
        \"Room2\": null,
        \"Room1\": \"237\"
      },"
      sections.concat course_string
        end
        sections.chop!
        sections.concat "], \"status_txt\": \"OK\"}"
        allow(subject).to receive(:open).and_return subject
        allow(subject).to receive(:read).and_return(sections, course_json)
        get :index
        expect(assigns(:courses).size).to be(500)
    end


    it "should handle course names with ASCII characters" do
      allow(subject).to receive(:open).and_return subject
      allow(subject).to receive(:read).and_return(course_json, section_json)
      get :index
      expect(assigns(:courses).first.course_title).to eq("COMPUTATIONAL GENOMICS")
    end

    it "should handle course names with Unicode characters" do
      allow(subject).to receive(:open).and_return subject
      unicode_course_json = course_json.gsub("COMPUTATIONAL GENOMICS", "\u2764\u2764\u2764")
      unicode_course_json.encode!("utf-8")
      allow(subject).to receive(:read).and_return(section_json, unicode_course_json)
      get :index
      expect(assigns(:courses).first.course_title).to eq("\u2764\u2764\u2764".encode("utf-8"))
    end

    it "should handle NULL course name" do
      allow(subject).to receive(:open).and_return subject
      titleless_course = course_json.gsub('"CourseTitle": "COMPUTATIONAL GENOMICS",', "")
      allow(subject).to receive(:read).and_return(section_json, titleless_course)
      get :index
      expect(assigns(:courses).first.course_title).to be_nil
    end

    it "should handle empty course name" do
      allow(subject).to receive(:open).and_return subject
      titleless_course = course_json.gsub("COMPUTATIONAL GENOMICS", "")
      allow(subject).to receive(:read).and_return(section_json, titleless_course)
      get :index
      expect(assigns(:courses).first.course_title).to be_empty
    end
  end

  context "when professor is edwards" do
    let (:user) { FactoryGirl.build(:professor) }

    it "should distinguish between two courses with the same title" do
      get :index
      subject.current_user.courses.count.should be(subject.current_user.courses.count('call_number', :distinct => true))
    end

    it "should not fail when the professor's name is only ASCII" do
      subject.current_user.firstname.should eq("Stephen".encode("utf-8"))
      get :index
    end
  end

  context "when professor has unicode name" do
    let (:user) { FactoryGirl.build(:professor, :firstname => "J\u00F6nathan".encode("utf-8")) }

    it "should not fail" do
      subject.current_user.firstname.should eq("J\u00F6nathan".encode("utf-8"))
      get :index
    end
  end
end
