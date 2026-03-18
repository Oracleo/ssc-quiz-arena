import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('SSC_ANNOUNCEMENT')
external JSObject? get _jsAnnouncement;

/// Reads announcement config from window.SSC_ANNOUNCEMENT (set by announcement.js).
Map<String, dynamic>? getJsAnnouncementConfig() {
  try {
    final jsObj = _jsAnnouncement;
    if (jsObj == null || jsObj.isUndefinedOrNull) return null;

    String str(String key) {
      final v = jsObj.getProperty<JSAny?>(key.toJS);
      if (v == null || v.isUndefinedOrNull) return '';
      return (v as JSString).toDart;
    }

    bool boolean(String key) {
      final v = jsObj.getProperty<JSAny?>(key.toJS);
      if (v == null || v.isUndefinedOrNull) return false;
      return (v as JSBoolean).toDart;
    }

    final enabled = boolean('enabled');
    if (!enabled) return null;

    return {
      'enabled': true,
      'type': str('type'),
      'icon': str('icon'),
      'title': str('title'),
      'subtitle': str('subtitle'),
      'badge': str('badge'),
    };
  } catch (e) {
    return null;
  }
}
