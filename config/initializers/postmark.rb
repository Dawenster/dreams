postmark_api_key = if Rails.env.production?
                     ENV.fetch('POSTMARK_API_TOKEN')
                   else
                     # https://postmarkapp.com/developer/api/overview
                     ENV['POSTMARK_API_TOKEN'] || 'POSTMARK_API_TEST'
                   end

POSTMARK = Postmark::ApiClient.new(postmark_api_key)

POSTMARK_DREAM_PURCHASED_RECIPIENT_TEMPLATE_ID = 11713168
POSTMARK_DREAM_PURCHASED_BUYER_TEMPLATE_ID = 11677762
POSTMARK_DREAM_CREATED_DONOR_TEMPLATE_ID = 11867792

SEND_DREAMS_EMAIL_SENDER = 'Dream Team <hello@senddreams.com>'.freeze
