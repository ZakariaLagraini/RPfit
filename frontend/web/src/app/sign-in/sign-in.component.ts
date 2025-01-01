import { Component } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { Location } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-sign-in',
  standalone: true,
  imports: [RouterModule, FormsModule, CommonModule],
  templateUrl: './sign-in.component.html',
  styleUrl: './sign-in.component.css'
})
export class SignInComponent {
  loginData = {
    email: '',
    password: ''
  };

  constructor(
    private location: Location,
    private router: Router
  ) {}

  onSubmit(): void {
    if (!this.loginData.email || !this.loginData.password) {
      alert('Please fill in all fields');
      return;
    }

    // Simulate successful login
    const mockUserProfile = {
      firstName: 'Hamza',
      lastName: 'El Aloui',
      age: 28,
      weight: 75,
      height: 180,
      fitnessGoal: 'Weight Loss',
      experienceLevel: 'Intermediate',
      profilePicture: 'assets/default-avatar.png',
      joinDate: new Date(),
      preferredTime: 'Morning',
      stats: {
        workoutsCompleted: 0,
        currentStreak: 0,
        totalMinutes: 0
      },
      achievements: []
    };

    localStorage.setItem('userProfile', JSON.stringify(mockUserProfile));
    this.router.navigate(['/']);
  }

  goBack(): void {
    this.location.back();
  }
}
