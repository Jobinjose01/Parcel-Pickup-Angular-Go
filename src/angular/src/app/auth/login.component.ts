import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { finalize, first } from 'rxjs/operators';

import { environment } from '@env/environment';
import { Logger, UntilDestroy, untilDestroyed } from '@shared';
import { AuthenticationService } from './authentication.service';
import jwt_decode from "jwt-decode";
import { Credentials, CredentialsService } from '../auth/credentials.service';

const log = new Logger('Login');

@UntilDestroy()
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  version: string | null = environment.version;
  error: string | undefined;
  loginForm!: FormGroup;
  isLoading = false;
  resultdata: any;
  errormsg: string | undefined;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private formBuilder: FormBuilder,
    private authenticationService: AuthenticationService,
    private credentialsService: CredentialsService
  ) {
    this.createForm();
  }

  ngOnInit() {}

  login() {
    this.isLoading = true;
    const login$ = this.authenticationService.authendicate(this.loginForm.value);
    login$
      .pipe(first())
      .subscribe(
        data => {
           this.resultdata = data;           
           this.isLoading = false;
          if(this.resultdata.status == 1) {
            let acces_token = this.credentialsService.getToken();
            let decodedHeader : any = jwt_decode(acces_token);

            if(decodedHeader.groups == 2){
               this.router.navigate([this.route.snapshot.queryParams.redirect || '/'], { replaceUrl: true });
            }else if(decodedHeader.groups == 3){
               this.router.navigate([this.route.snapshot.queryParams.redirect || '/bikerhome'], { replaceUrl: true });
            }else{
               this.router.navigate([this.route.snapshot.queryParams.redirect || '/'], { replaceUrl: true });
            }  

          }else{
             this.errormsg = this.resultdata.message;
             this.error = this.errormsg;
          }
        },
        (error) => {
          log.debug(`Login error: ${error}`);
          this.error = error;
        }
      );
  }

  private createForm() {
    this.loginForm = this.formBuilder.group({
      username: ['', Validators.required],
      password: ['', Validators.required],
      remember: true,
    });
  }
}
