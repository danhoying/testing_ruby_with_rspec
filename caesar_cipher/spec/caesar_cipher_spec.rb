require './lib/caesar_cipher'

describe "#caesar_cipher" do 

  it "shifts by given encryption key" do
    expect(caesar_cipher("hello", 7)).to eql "olssv"
  end

  it "only accepts numeric input for shift factor" do
    expect(caesar_cipher("hello", "foo")).to eql "Invalid shift factor.  Please enter a number."
  end

  it "shifts and preserves capital letters" do
    expect(caesar_cipher("welcome Bobby", 10)).to eql "govmywo Lylli"
  end

  it "shifts only alpha characters" do
    expect(caesar_cipher("hello, world!", 4)).to eql "lipps, asvph!"
  end

  it "handles shift factors greater than 26" do
    expect(caesar_cipher("hello, world!", 40)).to eql "vszzc, kcfzr!"
  end

  it "handles shift factor of 0" do
    expect(caesar_cipher("This is my sentence.", 0)).to eql "This is my sentence."
  end

  it "wraps around 'z' and 'Z'" do
    expect(caesar_cipher("This is my sentence.", 20)).to eql "Nbcm cm gs myhnyhwy."
  end
end
