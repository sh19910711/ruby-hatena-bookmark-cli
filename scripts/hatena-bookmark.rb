#!/usr/bin/env ruby

module HatenaBookmarkCLI
  require 'oauth'
  require 'atom'
  require 'fileutils'
  require 'active_support/core_ext'
  require 'highline/import'
  require 'readline'

  require_relative '../lib/hatena-bookmark-cli'

  def self.input_tag
    Readline.completion_append_character = nil
    Readline.completion_proc = proc { |s| @store[:tags].grep( /^#{Regexp.escape(s)}/ ) }
    tag = Readline.readline('> ')
    tag
  end

  def self.remove_tag(tags)
    Readline.completion_append_character = nil
    Readline.completion_proc = proc { |s| tags.grep( /^#{Regexp.escape(s)}/ ) }
    target_tag = Readline.readline('> ')
    tags.select {|tag| tag != target_tag}
  end

  def self.get_comment
    if @tags.empty?
      "#{@comment}"
    else
      tags = @tags.map {|tag| "[#{tag}]"}.join ""
      "#{tags} #{@comment}"
    end
  end

  def self.input_comment
    @comment = ""
    1000.times do
      choose do |menu|
        menu.prompt = "対応する番号か文字列を入力"

        menu.choice(:comment) do
          @comment = ask("コメントを入力")
        end

        menu.choice(:tag) do
          say "タグを1つ入力（TABキーを2回押すと補完候補が表示されます）"
          tag = input_tag
          @tags.push tag
          @tags.uniq!
        end

        menu.choice(:remove_tag) do
          say "削除するタグを1つ入力（TABキーを2回押すと補完候補が表示されます）"
          @tags = remove_tag(@tags)
          @tags.uniq!
        end

        menu.choice(:finish) do
          return get_comment
        end
      end

      say "現在のコメント=#{get_comment}\n\n"
    end
    comment
  end

  @store = Store.load
  @config = Config.load

  @tags = []
  @comment = ""
  @consumer = OAuth::Consumer.new(
    @config[:consumer_key],
    @config[:consumer_secret],
    :site => 'https://www.hatena.ne.jp',
    :request_token_path => '/oauth/initiate',
    :authorize_path     => '/oauth/authorize',
    :access_token_path  => '/oauth/token',
  )

  access_token = OAuth::AccessToken.new(
    @consumer,
    @store[:oauth_token],
    @store[:oauth_token_secret],
  )

  if ARGV.length == 1
    url = ARGV.shift.strip
    comment = input_comment

    entry = Atom::Entry.new do |e|
      e.links << Atom::Link.new(:href => url)
      e.summary = comment
    end

    puts "# 確認"
    puts "URL=#{url}"
    puts "Comment=#{comment}"
    puts ""
    ask("確定: Enter, キャンセル: Ctrl+C")

    post_xml_text = <<END_OF_XML
<entry xmlns="http://purl.org/atom/ns#">
  <title>dummy</title>
  <link rel="related" type="text/html" href="#{url}" />
  <summary type="text/plain">#{comment}</summary>
</entry>
END_OF_XML

    say "POST: http://b.hatena.ne.jp/atom/post"
    puts access_token.post("http://b.hatena.ne.jp/atom/post", post_xml_text, {'Content-Type'=>'application/xml'})
    
    edit_xml_text = <<END_OF_XML
<entry xmlns="http://purl.org/atom/ns#">
  <summary type="text/plain">#{comment}</summary>
</entry>
END_OF_XML
    
    say "PUT: http://b.hatena.ne.jp/atom/post"
    puts access_token.put("http://b.hatena.ne.jp/atom/edit/#{URI.encode url}", edit_xml_text, {'Content-Type'=>'application/xml'})

    ask "エンターキーで終了"
  else
    puts "Usage: command <url>"
  end
end
