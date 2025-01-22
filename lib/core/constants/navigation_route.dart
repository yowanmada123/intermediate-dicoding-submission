enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  detailNotificationRoute("/detail/notification"),
  settingRoute("/setting"),
  settingDetailRoute("/setting/detail");

  const NavigationRoute(this.name);
  final String name;
}
