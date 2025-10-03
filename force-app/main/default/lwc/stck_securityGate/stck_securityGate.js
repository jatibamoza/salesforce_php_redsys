import { LightningElement, track } from 'lwc';
import sendVerificationCode from '@salesforce/apex/STCK_SecurityController.sendVerificationCode';
import verifyCode from '@salesforce/apex/STCK_SecurityController.verifyCode';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Stck_securityGate extends LightningElement {
    @track verificationState = 'enterEmail';
    @track email = '';
    code = '';
    isLoading = false;

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        const isVerifiedFromUrl = urlParams.get('verified') === 'true';
        const isVerifiedFromStorage = sessionStorage.getItem('isLaLigaEmployeeVerified') === 'true';

        if (isVerifiedFromUrl || isVerifiedFromStorage) {
            this.verificationState = 'verified';
        } else {
            this.verificationState = 'enterEmail';
        }
    }

    get cardTitle() {
        switch (this.verificationState) {
            case 'enterEmail':
                return 'Acceso a la Tienda de Empleados';
            case 'enterCode':
                return 'Verificar Código';
            case 'verified':
                return ''; 
            default:
                return 'Tienda de Empleados';
        }
    }

    get showEmailScreen() {
        return this.verificationState === 'enterEmail';
    }
    get showCodeScreen() {
        return this.verificationState === 'enterCode';
    }
    get isVerified() {
        return this.verificationState === 'verified';
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleCodeChange(event) {
        this.code = event.target.value;
    }

    handleSendCodeClick() {
        if (!this.email || !this.email.includes('@')) {
            this.showToast('Error', 'Por favor, introduce un correo electrónico válido.', 'error');
            return;
        }
        this.isLoading = true;
        sendVerificationCode({ email: this.email })
            .then(() => {
                this.verificationState = 'enterCode';
                this.isLoading = false;
                this.showToast('Éxito', 'Código de verificación enviado a tu correo.', 'success');
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('Error', error.body.message, 'error');
            });
    }

    handleVerifyCodeClick() {
        if (!this.code || this.code.length !== 6) {
            this.showToast('Error', 'El código debe tener 6 dígitos.', 'error');
            return;
        }
        this.isLoading = true;
        verifyCode({ email: this.email, code: this.code })
            .then(result => {
                this.isLoading = false;
                if (result) {
                    sessionStorage.setItem('isLaLigaEmployeeVerified', 'true');
                    
                    this.verificationState = 'verified';
                } else {
                    this.showToast('Error', 'El código es incorrecto o ha expirado.', 'error');
                }
            })
            .catch(error => {
                this.isLoading = false;
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}