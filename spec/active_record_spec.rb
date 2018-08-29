require "spec_helper"

describe ActiveRecord do

  describe "#new" do
    it "should create a new Post" do
      post = Post.new(id: 1, title: "A cool post")
      expect(post.id).to eql 1
      expect(post.title).to eql "A cool post"
    end
  end

  describe "#find" do
    it "should find an existing Post" do
      post = Post.find(1)
      expect(post).to be_a Post
      expect(post.id).to eql 1
      expect(post.title).to eql "A new post"
    end
  end

  describe "#execute" do
    it "should execute the given SQL" do
      rows  = Post.connection.execute("SELECT * FROM posts")
      expect(rows).to be_an Array
      row = rows.first
      expect(row).to be_a Hash
      expect(row.keys).to match_array [:id, :title, :body, :created_at, :updated_at]
    end
  end

  describe "#all" do
    it "should return an array of all posts" do
      post = Post.all.first
      expect(post).to be_a Post
      expect(post.id).to eql 1
      expect(post.title).to eql "A new post"
    end
  end

  describe "#table_name" do
    it "should return the table name" do
      expect(Post.table_name).to eql "posts"
    end
  end

  describe "#method_missing" do
    it "should return the column value generically" do
      post = Post.find(1)
      expect(post.id).to eql 1
      expect(post.title).to eql "A new post"
      expect { post.notexist }.to raise_error(NoMethodError)
    end
  end

  describe "#where" do

    context "single where call" do
      it "should construct a query" do
        relation = Post.where("id = 2")
        expect(relation.to_sql).to eql "SELECT * FROM posts WHERE id = 2"
      end
    end

    context "chained where calls" do
      it "should construct a query" do
        relation = Post.where("id = 2").where("title IS NOT NULL")
        expect(relation.to_sql).to eql "SELECT * FROM posts WHERE id = 2 AND title IS NOT NULL"
      end
    end
  end
end
