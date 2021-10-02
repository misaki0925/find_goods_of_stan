module LoginModule
  def login(user)
    visit admins_login_path
    fill_in (I18n.t('admins.sessions.new.email')),	with: user.email
    fill_in (I18n.t('admins.sessions.new.password')),	with: 'password'
    click_button (I18n.t('admins.sessions.new.login'))
  end
end
