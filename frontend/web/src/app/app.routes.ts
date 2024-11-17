import { Routes } from '@angular/router';
import { SignupComponent } from './signup/signup.component';
import { HomeComponent } from './home/home.component';
import { SignInComponent } from './sign-in/sign-in.component';
import { ProfileCreationComponent } from './profile-creation/profile-creation.component';
import { ProfileComponent } from './profile/profile.component';

export const routes: Routes = [
    { path: '', component: HomeComponent }, 
    { path: 'sign-up', component: SignupComponent }, 
    { path: 'sign-in', component: SignInComponent },
    { path: 'profile-creation', component: ProfileCreationComponent },
    { path: 'profile', component: ProfileComponent },
    {
        path: 'exercises',
        loadComponent: () => import('./exercises/exercises/exercises.component').then(m => m.ExercisesComponent),
        children: [
            {
                path: 'weight-loss',
                loadComponent: () => import('./exercises/weight-loss/weight-loss.component').then(m => m.WeightLossComponent)
            },
            {
                path: 'muscle-gain',
                loadComponent: () => import('./exercises/muscle-gain/muscle-gain.component').then(m => m.MuscleGainComponent)
            },
            {
                path: 'maintenance',
                loadComponent: () => import('./exercises/maintenance/maintenance.component').then(m => m.MaintenanceComponent)
            },
            {
                path: 'flexibility',
                loadComponent: () => import('./exercises/flexibility/flexibility.component').then(m => m.FlexibilityComponent)
            },
            { 
                path: '', 
                redirectTo: 'weight-loss', 
                pathMatch: 'full' 
            }
        ]
    }
];


