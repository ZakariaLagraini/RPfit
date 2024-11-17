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
    // Basic validation
    if (!this.userData.name || !this.userData.email || !this.userData.password) {
      alert('Please fill in all fields');
      return;
    }
    
    if (this.userData.password !== this.userData.confirmPassword) {
      alert('Passwords do not match');
      return;
    }

    // Here you would typically make an API call to create the user
    console.log('Form submitted:', this.userData);
    
    // Navigate to profile creation
    this.router.navigate(['/profile-creation']);
  }

  goBack(): void {
    this.location.back();
  }
}
