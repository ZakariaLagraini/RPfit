import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { Router, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Location } from '@angular/common';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './signup.component.html',
  styleUrl: './signup.component.css'
})
export class SignupComponent {
  userData = {
    name: '',
    email: '',
    password: '',
    confirmPassword: ''
  };

  constructor(private router: Router, private location: Location) {}

  onSubmit(): void {
    if (!this.userData.name || !this.userData.email || !this.userData.password) {
      alert('Please fill in all fields');
      return;
    }
    
    if (this.userData.password !== this.userData.confirmPassword) {
      alert('Passwords do not match');
      return;
    }

    // Create initial profile data
    const [firstName, ...lastNameParts] = this.userData.name.split(' ');
    const lastName = lastNameParts.join(' ');
    
    const initialProfile = {
      firstName,
      lastName,
      profilePicture: 'assets/default-avatar.png',
      email: this.userData.email
    };

    // Store initial profile data
    localStorage.setItem('userProfile', JSON.stringify(initialProfile));
    
    // Navigate to profile creation to complete the profile
    this.router.navigate(['/profile-creation']);
  }

  goBack(): void {
    this.location.back();
  }
}
