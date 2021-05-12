class ErrorList {
  static String showError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Bu e-mail adresi kullanılmaktadır.';
        break;
      case 'wrong-password':
        return 'Girilen şifre hatalıdır';
        break;
      case 'user-not-found':
        return 'Kullanıcı bulunamadı';
        break;
      default:
        return 'Bir hata oluştu.';
    }
  }
}
