import 'package:aldoc/main.dart';
import 'package:flutter/foundation.dart';

String? _lang = language;

class Language with ChangeNotifier {
  getLanguage() {
    return _lang;
  }

  setLanguage(String? lang) {
    _lang = lang;
    notifyListeners();
  }

  String tDrawerLanguage() {
    if (getLanguage() == "AR") {
      return "اللغة";
    } else if (getLanguage() == "FR") {
      return "Langue";
    } else {
      return "Language";
    }
  }

  String tDrawerLogin() {
    if (getLanguage() == "AR") {
      return "تسجيل الدخول";
    } else if (getLanguage() == "FR") {
      return "Connexion";
    } else {
      return "Log In";
    }
  }

  String tDrawerAbout() {
    if (getLanguage() == "AR") {
      return "التفاصيل";
    } else if (getLanguage() == "FR") {
      return "détails";
    } else {
      return "about";
    }
  }

  String tHomeFavoriteFiles() {
    if (getLanguage() == "AR") {
      return "الملفات المفضلة";
    } else if (getLanguage() == "FR") {
      return "Fichiers favoris";
    } else {
      return "Favorite files";
    }
  }

  String tHomeAllFiles() {
    if (getLanguage() == "AR") {
      return "جميع الملفات";
    } else if (getLanguage() == "FR") {
      return "Tous les fichiers";
    } else {
      return "All Files";
    }
  }

  String tHomeAllResult() {
    if (getLanguage() == "AR") {
      return "كل النتائج";
    } else if (getLanguage() == "FR") {
      return "Tous les résultats";
    } else {
      return "All result";
    }
  }

  String tHomeFiltredBy() {
    if (getLanguage() == "AR") {
      return "تصفية حسب";
    } else if (getLanguage() == "FR") {
      return "Filtrer par";
    } else {
      return "Filter by";
    }
  }

  String tHomeFilter() {
    if (getLanguage() == "AR") {
      return "تصفيه";
    } else if (getLanguage() == "FR") {
      return "Filtre";
    } else {
      return "Filter";
    }
  }

  String tHomeFilterDocumentType() {
    if (getLanguage() == "AR") {
      return "نوع الوثيقة";
    } else if (getLanguage() == "FR") {
      return "Document Type";
    } else {
      return "Document Type";
    }
  }

  String tHomeFilterIdDocument() {
    if (getLanguage() == "AR") {
      return "وثيقة الهوية";
    } else if (getLanguage() == "FR") {
      return "Carte d'identité";
    } else {
      return "Id Document";
    }
  }

  String tHomeFilterBusinessCard() {
    if (getLanguage() == "AR") {
      return "بطاقة الأعمال";
    } else if (getLanguage() == "FR") {
      return "Carte de visite";
    } else {
      return "Business Card";
    }
  }

  String tHomeFilterInvoice() {
    if (getLanguage() == "AR") {
      return "فاتورة";
    } else if (getLanguage() == "FR") {
      return "Facture";
    } else {
      return "Invoice";
    }
  }

  String tHomeFilterPassport() {
    if (getLanguage() == "AR") {
      return "جواز سفر";
    } else if (getLanguage() == "FR") {
      return "Passeport";
    } else {
      return "Passport";
    }
  }

  String tHomeFilterClearAll() {
    if (getLanguage() == "AR") {
      return "مسح الكل";
    } else if (getLanguage() == "FR") {
      return "Effacer tout";
    } else {
      return "Clear All";
    }
  }

  String tUploadText() {
    if (getLanguage() == "AR") {
      return "\n\n  انقر للتصفح بحثا عن صورة مسموح بها \n       (PDF ، TIFF ، JPEG ، PNG) ";
    } else if (getLanguage() == "FR") {
      return "  \n\n  cliquez pour rechercher l’image xd \n    (Autorisé :PDF, TIFF, JPEG, PNG)";
    } else {
      return "  \n\n  click to browse for image xd \n(Allowed :PDF, TIFF, JPEG, PNG)";
    }
  }

  String tProfilEditPhoto() {
    if (getLanguage() == "AR") {
      return "تعديل الصورة";
    } else if (getLanguage() == "FR") {
      return "Modifier la photo";
    } else {
      return "Edit photo";
    }
  }

  String tProfilEditUsername() {
    if (getLanguage() == "AR") {
      return "تعديل اسم المستخدم";
    } else if (getLanguage() == "FR") {
      return "Modifier le nom d’utilisateur";
    } else {
      return "Edit username";
    }
  }

  String tProfilUsername() {
    if (getLanguage() == "AR") {
      return " اسم المستخدم";
    } else if (getLanguage() == "FR") {
      return " Nom d’utilisateur";
    } else {
      return "Username";
    }
  }

  String tProfilLogout() {
    if (getLanguage() == "AR") {
      return "تسجيل الخروج";
    } else if (getLanguage() == "FR") {
      return "déconnexion";
    } else {
      return "Logout";
    }
  }

  String tProfilEnterUserName() {
    if (getLanguage() == "AR") {
      return "أدخل اسم المستخدم";
    } else if (getLanguage() == "FR") {
      return "Entrez le nom d’utilisateur";
    } else {
      return "Enter username";
    }
  }

  String tProfilButtonSave() {
    if (getLanguage() == "AR") {
      return "حفظ";
    } else if (getLanguage() == "FR") {
      return "enregistrer";
    } else {
      return "Save";
    }
  }

  String tProfilButtonCancel() {
    if (getLanguage() == "AR") {
      return "إلغاء";
    } else if (getLanguage() == "FR") {
      return "Annuler";
    } else {
      return "Cancel";
    }
  }

  String tLoginHello() {
    if (getLanguage() == "AR") {
      return "مرحبا";
    } else if (getLanguage() == "FR") {
      return "Bonjour";
    } else {
      return "Hello";
    }
  }

  String tLoginMessage() {
    if (getLanguage() == "AR") {
      return "تسجيل الدخول إلى حسابك";
    } else if (getLanguage() == "FR") {
      return "Connectez-vous à votre compte";
    } else {
      return "Sign in into your account";
    }
  }

  String tLoginEmail() {
    if (getLanguage() == "AR") {
      return "البريد الإلكتروني";
    } else if (getLanguage() == "FR") {
      return "Email";
    } else {
      return "Email";
    }
  }

  String tLoginEmailMessage() {
    if (getLanguage() == "AR") {
      return "أدخل بريدك الإلكتروني";
    } else if (getLanguage() == "FR") {
      return "Entrez votre adresse e-mail";
    } else {
      return "Enter your email";
    }
  }

  String tLoginEmailErrorMessage() {
    if (getLanguage() == "AR") {
      return "أدخل عنوان بريد إلكتروني صالح";
    } else if (getLanguage() == "FR") {
      return "Entrez une adresse e-mail valide";
    } else {
      return "Enter a valid email addresss";
    }
  }

  String tLoginPassword() {
    if (getLanguage() == "AR") {
      return "*كلمة المرور";
    } else if (getLanguage() == "FR") {
      return "Mot de passe*";
    } else {
      return "Password*";
    }
  }

  String tLoginPasswordMessage() {
    if (getLanguage() == "AR") {
      return "أدخل كلمة المرور";
    } else if (getLanguage() == "FR") {
      return "Entrez votre mot de passe";
    } else {
      return "Enter your password";
    }
  }

  String tLoginButton() {
    if (getLanguage() == "AR") {
      return "تسجيل الدخول ";
    } else if (getLanguage() == "FR") {
      return "Connexion";
    } else {
      return "Sign in";
    }
  }

  String tLoginForgotPassword() {
    if (getLanguage() == "AR") {
      return " نسيت كلمة المرور؟";
    } else if (getLanguage() == "FR") {
      return "Mot de passe oublié? ";
    } else {
      return "Forgot Password? ";
    }
  }

  String tLoginHaveAccount() {
    if (getLanguage() == "AR") {
      return "  ليس لديك حساب؟ ";
    } else if (getLanguage() == "FR") {
      return "Vous n’avez pas de compte?  ";
    } else {
      return "Don't have an account ?";
    }
  }

  String tLoginCreate() {
    if (getLanguage() == "AR") {
      return "انشاء ";
    } else if (getLanguage() == "FR") {
      return "Créer";
    } else {
      return "Create";
    }
  }

  String tRegisterFirstName() {
    if (getLanguage() == "AR") {
      return "الاسم";
    } else if (getLanguage() == "FR") {
      return "Prénom";
    } else {
      return "First Name";
    }
  }

  String tRegisterFirstNameMessage() {
    if (getLanguage() == "AR") {
      return "أدخل الاسم";
    } else if (getLanguage() == "FR") {
      return "Entrez votre prénom";
    } else {
      return "Enter your first name";
    }
  }

  String tRegisterLastName() {
    if (getLanguage() == "AR") {
      return "اسم العائلة ";
    } else if (getLanguage() == "FR") {
      return "Nom du famille";
    } else {
      return "Last Name";
    }
  }

  String tRegisterLastNameMessage() {
    if (getLanguage() == "AR") {
      return "أدخل اسم العائلة ";
    } else if (getLanguage() == "FR") {
      return "Entrez votre nom du famille";
    } else {
      return "Enter your last name";
    }
  }

  String tRegisterConfirmPassword() {
    if (getLanguage() == "AR") {
      return "*تأكيد كلمة المرور";
    } else if (getLanguage() == "FR") {
      return "Confirmer le mot de passe*";
    } else {
      return "Confirm password*";
    }
  }

  String tRegisterConfirmPasswordMessage() {
    if (getLanguage() == "AR") {
      return "أدخل كلمة المرور المؤكدة الخاصة بك";
    } else if (getLanguage() == "FR") {
      return "Entrez votre mot de passe de confirmation";
    } else {
      return "Enter your confirm password";
    }
  }

  String tRegisterOrganization() {
    if (getLanguage() == "AR") {
      return "المؤسسة";
    } else if (getLanguage() == "FR") {
      return "Organisation";
    } else {
      return "Organization";
    }
  }

  String tRegisterOrganizationMessage() {
    if (getLanguage() == "AR") {
      return "أدخل مؤسستك";
    } else if (getLanguage() == "FR") {
      return "Entrez  votre organisation";
    } else {
      return "Enter your organization";
    }
  }

  String tRegisterConditions() {
    if (getLanguage() == "AR") {
      return "أوافق على جميع الشروط والأحكام";
    } else if (getLanguage() == "FR") {
      return "J’accepte tous les termes et conditions";
    } else {
      return "I accept all terms and conditions";
    }
  }

  String tRegisterErrorConditions() {
    if (getLanguage() == "AR") {
      return "تحتاج إلى قبول الشروط والأحكام";
    } else if (getLanguage() == "FR") {
      return "Vous devez accepter les termes et conditions";
    } else {
      return "You need to accept terms and conditions";
    }
  }

  String tRegisterButton() {
    if (getLanguage() == "AR") {
      return "سجل";
    } else if (getLanguage() == "FR") {
      return "Registre";
    } else {
      return "Register";
    }
  }

  String tForgorPasswordMessage1() {
    if (getLanguage() == "AR") {
      return "أدخل عنوان البريد الإلكتروني المرتبط بحسابك";
    } else if (getLanguage() == "FR") {
      return "Entrez l’adresse e-mail associée à votre compte.";
    } else {
      return "Enter the email address associated with your account.";
    }
  }

  String tForgorPasswordMessage2() {
    if (getLanguage() == "AR") {
      return "سنرسل لك رمز التحقق عبر البريد الإلكتروني للتحقق من مصداقيتك.";
    } else if (getLanguage() == "FR") {
      return "Nous vous enverrons un code de vérification par e-mail pour vérifier votre authenticité.";
    } else {
      return "We will email you a verification code to check your authenticity.";
    }
  }

  String tForgorPasswordMessage3() {
    if (getLanguage() == "AR") {
      return " تذكر كلمة المرور الخاصة بك؟ ";
    } else if (getLanguage() == "FR") {
      return "Vous vous souvenez \n de votre mot de passe? ";
    } else {
      return "Remember your password? ";
    }
  }

  String tForgorPasswordButton() {
    if (getLanguage() == "AR") {
      return "ارسل";
    } else if (getLanguage() == "FR") {
      return "Envoyer";
    } else {
      return "Send";
    }
  }

  String tVerificationCodeSentMessage() {
    if (getLanguage() == "AR") {
      return "تم إرسال رمز التحقق ";
    } else if (getLanguage() == "FR") {
      return "Le code de vérification a été envoyé";
    } else {
      return "Verification code has been sent ";
    }
  }

  String tVerificationCodeSentErrorMessage() {
    if (getLanguage() == "AR") {
      return "عفوا ، فشل إرسال الرمز";
    } else if (getLanguage() == "FR") {
      return "Oups, échec de l’envoi du code";
    } else {
      return "Oops, code send failed";
    }
  }

  String tVerificationCodeEmailMessageName() {
    if (getLanguage() == "AR") {
      return "التحقق من رمز البريد الإلكتروني";
    } else if (getLanguage() == "FR") {
      return "Verification du code e-mail";
    } else {
      return "Email code verification";
    }
  }

  String tVerificationMessage1() {
    if (getLanguage() == "AR") {
      return "التحقق";
    } else if (getLanguage() == "FR") {
      return "Vérification";
    } else {
      return "Verification";
    }
  }

  String tVerificationMessage2() {
    if (getLanguage() == "AR") {
      return "أدخل رمز التحقق الذي أرسلناه لك للتو على عنوان بريدك الإلكتروني";
    } else if (getLanguage() == "FR") {
      return "Entrez le code de vérification que nous venons de vous envoyer sur votre adresse e-mail.";
    } else {
      return "Enter the verification code we just sent you on your email address.";
    }
  }

  String tVerificationMessage3() {
    if (getLanguage() == "AR") {
      return "إذا لم تتلق رمزا! ";
    } else if (getLanguage() == "FR") {
      return "Si vous n’avez pas reçu de code ! ";
    } else {
      return "If you didn't receive a code! ";
    }
  }

  String tVerificationButton() {
    if (getLanguage() == "AR") {
      return "ارسال";
    } else if (getLanguage() == "FR") {
      return "Renvoyer";
    } else {
      return "Resend";
    }
  }

  String tVerificationMessage4() {
    if (getLanguage() == "AR") {
      return "تمت إعادة إرسال رمز التحقق بنجاح.";
    } else if (getLanguage() == "FR") {
      return "Le renvoi du code de vérification a réussi.";
    } else {
      return "Verification code resend successful.";
    }
  }

  String tVerificationMessage5() {
    if (getLanguage() == "AR") {
      return "تم التحقق من البريد الإلكتروني";
    } else if (getLanguage() == "FR") {
      return "L’adresse e-mail est vérifiée";
    } else {
      return "Email is verified";
    }
  }

  String tVerificationMessage6() {
    if (getLanguage() == "AR") {
      return "رمز غير صالح";
    } else if (getLanguage() == "FR") {
      return "Code non valide";
    } else {
      return "Invalid Code";
    }
  }

  String tVerificationButton2() {
    if (getLanguage() == "AR") {
      return "التحقق";
    } else if (getLanguage() == "FR") {
      return "Vérifier";
    } else {
      return "Verify";
    }
  }

  String tAddNewPasswordMessage1() {
    if (getLanguage() == "AR") {
      return "أدخل كلمة المرور الجديدة ";
    } else if (getLanguage() == "FR") {
      return "Entrez le nouveau mot de passe .";
    } else {
      return "Enter the new password .";
    }
  }
}
