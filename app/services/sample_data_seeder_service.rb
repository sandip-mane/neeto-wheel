# frozen_string_literal: true

class SampleDataSeederService
  ORGANIZATIONS = ["Spinkart"]

  def process
    ORGANIZATIONS.each do |org_name|
      org     = create_organization(org_name)
      oliver  = create_oliver(org)

      org.update(creator: oliver)
    end
  end

  private
    def create_organization(name)
      Organization.find_or_create_by(name: name, subdomain: name.parameterize)
    end

    def create_oliver(organization)
      create_user \
        email: "oliver@example.com",
        organization_id: organization.id,
        first_name: "Oliver",
        last_name: "Smith"
    end

    def create_user(options = {})
      ap options
      User.create! options.merge({ password: "welcome" })
    end
end
