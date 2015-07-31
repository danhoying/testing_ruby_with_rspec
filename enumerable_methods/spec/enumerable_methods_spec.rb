require './lib/enumerable_methods'

describe Enumerable do

  let(:array) {[1, 2, 3, 4, 5]}
  let(:empty_array) {[]}
  let(:nil_array) {[1, 2, nil, 3, 4, 5]}
  let(:false_array) {[nil, nil, false]}

  describe "#my_each" do

    context "without block" do
      it "returns an enumerator" do
        expect(array.my_each).to be_instance_of Enumerator
      end
    end

    context "with block" do
      it "iterates through an array and applies block instructions" do
        expect(array.my_each { |x| empty_array << x + 1 }).to eql array
        expect(empty_array).to eql [2, 3, 4, 5, 6]
      end

      it "returns empty array when given empty array" do
        expect([].my_each { |x| empty_array << x + 1}).to eql []
        expect(empty_array).to eql []
      end
    end
  end

  describe "#my_select" do

    context "without block" do
      it "returns an enumerator" do
        expect(array.select).to be_instance_of Enumerator
      end
    end

    context "with block" do
      it "only returns elements that cause the block to return true" do
        expect(array.select { |x| x.even? }).to eql [2,4]
        expect(empty_array.select { |x| x.even? }).to eql empty_array
        expect(nil_array.select { |x| x.nil? }).to eql [nil]
      end
    end
  end

  describe "#my_all?" do

    context "without block" do
      it "returns true when no elements are false or nil" do
        expect(array.my_all?).to eql true
      end

      it "returns false when any elements are false or nil" do
        expect(nil_array.my_all?).to eql false
      end
    end

    context "with block" do
      it "returns true if all elements return true" do
        expect(array.my_all? { |x| x > 0 }).to eql true
        expect(array.my_all? { |x| x }).to eql true
        expect(false_array.my_all? { |x| x == false || x == nil }).to eql true
      end

      it "returns false if any elements return false" do
        expect(array.my_all? { |x| x > 10 }).to eql false
        expect(nil_array.my_all? { |x| x }).to eql false
        expect(array.my_all? { |x| x > 2 }).to eql false
      end
    end
  end

  describe "#my_any?" do

    context "without block" do
      it "returns true when any elements are true" do
        expect(array.my_any?).to eql true
        expect(nil_array.my_any?).to eql true
      end

      it "returns false when no elements are true" do
        expect(false_array.my_any?).to eql false
      end
    end

    context "with block" do
      it "returns true if any elements return true" do
        expect(array.my_any? { |x| x > 0 }).to eql true
        expect(array.my_any? { |x| x }).to eql true
        expect(array.my_any? { |x| x > 4 }).to eql true
        expect(nil_array.my_any? { |x| x }).to eql true
      end

      it "returns false if no elements return true" do
        expect(array.my_any? { |x| x > 10 }).to eql false
        expect(false_array.my_any? { |x| x }).to eql false
      end
    end
  end

  describe "#my_count" do

    context "without block or argument" do
      it "returns number of elements in array" do
        expect(array.my_count).to eql 5
      end
    end

    context "with argument" do
      it "returns number of elements equal to argument value" do
        expect(array.my_count(3)).to eql 1
        expect(empty_array.my_count(3)).to eql 0
        expect(false_array.my_count(nil)).to eql 2
      end
    end

    context "with block" do
      it "returns number of elements yielding a true value" do
        expect(array.my_count { |x| x.even? }).to eql 2
        expect(array.my_count { |x| x.eql? 10 }).to eql 0
        expect(false_array.my_count { |x| x.eql? nil }).to eql 2
      end
    end
  end

  describe "#my_inject" do

    context "without initial value" do
      it "combines all elements by applying block instructions" do
        expect(array.my_inject { |sum, x| sum + x }).to eql 15
        expect(array.my_inject { |product, x| product * x }).to eql 120
      end
    end

    context "with initial value" do
      it "combines all elements by applying block instructions to initial value" do
        expect(array.my_inject(2) { |sum, x| sum + x }).to eql 17
        expect(array.my_inject(0) { |sum, x| sum + x }).to eql 15
        expect(array.my_inject(2) { |product, x| product * x }).to eql 240
        expect(array.my_inject(0) { |product, x| product * x }).to eql 0
      end
    end
  end
end