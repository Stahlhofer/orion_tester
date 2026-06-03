class ColumnMapper {
  static String? findColumn(
    List<String> headers,
    List<String> aliases,
  ) {
    for (final alias in aliases) {
      try {
        return headers.firstWhere(
          (h) => h.trim().toLowerCase() == alias.trim().toLowerCase(),
        );
      } catch (_) {}
    }

    return null;
  }
}
