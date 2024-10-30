import { Routes } from '@angular/router';
import { SignupComponent } from './signup/signup.component';
import { HomeComponent } from './home/home.component';
import { SignInComponent } from './sign-in/sign-in.component';

export const routes: Routes = [
    { path: '', component: HomeComponent }, 
    { path: 'sign-up', component: SignupComponent }, 
    { path: 'sign-in', component: SignInComponent },
];


