require 'rails_helper'

describe "ParseGitStats" do

  describe 'link_similar_authors_and_their_commits' do

    before :each do
      author1 = Author.create name:"Ola" , email:"ola@copter.com"
      author2 = Author.create name:"Ola" , email:"blaablaa"
      author3 = Author.create name:"NotOla" , email:"ola@copter.com"
      commit1 = Commit.create repository_id:0, author_id:1, sha:"1" , stamp:1
      commit2 = Commit.create repository_id:0, author_id:2, sha:"1" , stamp:1
      commit3 = Commit.create repository_id:0, author_id:3, sha:"1" , stamp:1
      commit4 = Commit.create repository_id:0, author_id:1, sha:"1" , stamp:1
    end

    it 'links commits from duplicate authors correctly' do
      ParseGitStats.link_similar_authors_and_their_commits
      expect(Author.find(1).commits.count).to eq(4)
    end

    it 'links authors correctly' do
      ParseGitStats.link_similar_authors_and_their_commits
      authors = Author.where.not(linked_id:nil)
      expect(authors.count).to eq(2)
      expect(authors.pluck(:linked_id).uniq).to eq([1])

    end

  end
end