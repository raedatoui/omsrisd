OMS.config do |config|
  config.site_title = 'OMS: Risd'

  # config.autopromote do
  #   promote :exhibitions, :program_series, :exhibition_series do
  #     start :start_date, -> date { date - 30.days }
  #     finish :end_date
  #     suppress :if, -> record { record.respond_to?(:is_micro) && record.is_micro }
  #   end

  #   promote :events, :programs do
  #     start :date, -> date { date - 1.week }
  #     finish :date
  #   end

  #   promote :posts, :miranda_posts do
  #     start :publish_date
  #     finish :publish_date, -> date { date + 30.days }
  #   end
  # end

  config.draftable :all, except: [:images, :videos, :audios]

  config.uploader do
    version :thumb do
      process :resize_to_fit => [164, 200000]
    end

    version :small do
      process :resize_to_fit => [270, 200000]
    end

    version :medium do
      process :resize_to_fit => [594, 200000]
    end

    version :large do
      process :resize_to_fit => [840, 200000]
    end

    def move_to_cache
      true
    end

    def move_to_store
      true
    end

  end

  config.consumer_root = case Rails.env
  when 'staging'
    "http://othermeans.business"
  when 'production'
    "http://othermeans.business"
  when 'development'
    "http://om.dev"
  end

  config.javascript 'oms/overrides.js'
  config.javascript 'oms/sir-trevor/blocks.js'
  config.javascript 'oms/sir-trevor/patches.js'
  config.stylesheet 'oms_overrides.css'

  config.sir_trevor_options = {
    blockTypes: [
      "Text", "Node", "Group", "List", "Field", "Code", "SocialLinks"
    ]
  }

  config.consumer_uri_for "OMS::Node" do |node|
    token = node.node_type.token
    "/#{token}/#{node.id}/#{node.name.parameterize}"
  end

  config.embed :node do |data|
    node = OMS::Node.where(id: data["id"]).first
    if node && node.file?
      "<img src='#{node.file.medium.url}' alt='#{node.name}'>"
    end
  end

  config.embed :list, :field do |parent, data|
    nodes = parent.related_nodes.of_type(data["token"])
    return unless nodes.any?
    nodes.collect do |n|
      "<a href='#{OMS.consumer_url_for(n)}'>#{n.name}</a>"
    end.join
  end

  config.embed :group do |parent, data|
    relationships = parent.relationships.tagged_with(data['name'])
    related = OMS::Node.where(id: relationships.collect(&:related_id)).all
    related.collect do |n|
      "<a href='#{OMS.consumer_url_for(n)}'>#{n.name}</a>"
    end.join
  end

  config.batchable :images

end
