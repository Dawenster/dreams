class EnableInitialExtensions < ActiveRecord::Migration[5.2]
  def change
    %w(
      uuid-ossp
      pgcrypto
      btree_gist
    ).each { |e| enable_extension(e) }
  end
end
