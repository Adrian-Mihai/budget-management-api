RSpec.shared_examples 'not valid and contain errors' do
  it 'should not be valid' do
    expect(subject.valid?).to be false
  end

  it 'should contain a error message' do
    expect(subject.errors).not_to be_empty
  end
end

RSpec.shared_examples 'valid and not contain errors' do
  it 'should be valid' do
    expect(subject.valid?).to be true
  end

  it 'should not contain a error message' do
    expect(subject.errors).to be_empty
  end
end
