module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def check_permit_delete user
    return unless current_user.admin? && !current_user?(user)

    link_to t("delete_user.title_delete"),
            user, method: :delete, data: {confirm: t("delete_user.u_sure")}
  end
end
