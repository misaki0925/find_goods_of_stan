module LoginModule
  def login(user)
    visit admins_login_path
    fill_in (I18n. t('activerecord.attributes.member.email')),	with: user.email
    fill_in (I18n. t('activerecord.attributes.member.password')),	with: 'password'
    click_button (I18n.t('defaults.login'))
  end
end
