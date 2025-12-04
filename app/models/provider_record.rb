class ProviderRecord < ApplicationRecord
  belongs_to :content

  def adding(provider_ids, added)
    provider_ids.each do |pid|
      puts "  #{pid[:provider_name]}✅"
      ProviderRecord.create!(
        content_id: added.id,
        provider_name: pid[:provider_name],
        provider_content_id: pid[:provider_content_id]
      )
    end
  end

  def already_exists?(provider_name:, provider_content_id:)
      if ProviderRecord.exists?(provider_name: provider_name, provider_content_id: provider_content_id)
        puts "exists⏭️"
        return true
      else
        return false
      end
  end
end
