import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { Location } from '@angular/common';

interface UserProfile {
  firstName: string;
  lastName: string;
  age: number;
  weight: number;
  height: number;
  fitnessGoal: string;
  experienceLevel: string;
  profilePicture: string;
  joinDate: Date;
  preferredTime: string;
  stats: {
    workoutsCompleted: number;
    currentStreak: number;
    totalMinutes: number;
  };
  achievements: Array<{
    icon: string;
    title: string;
    date: Date;
  }>;
}

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  userProfile: UserProfile = {
    firstName: 'Hamza',
    lastName: 'El Aloui',
    age: 28,
    weight: 75,
    height: 180,
    fitnessGoal: 'Weight Loss',
    experienceLevel: 'Intermediate',
    profilePicture: 'assets/default-avatar.png',
    joinDate: new Date(2024, 0, 15),
    preferredTime: 'Morning',
    stats: {
      workoutsCompleted: 48,
      currentStreak: 7,
      totalMinutes: 1440
    },
    achievements: [
      {
        icon: 'fas fa-fire',
        title: '7 Day Streak',
        date: new Date(2024, 2, 15)
      },
      {
        icon: 'fas fa-dumbbell',
        title: 'First 50 Workouts',
        date: new Date(2024, 2, 10)
      },
      {
        icon: 'fas fa-clock',
        title: '24 Hours of Training',
        date: new Date(2024, 2, 5)
      }
    ]
  };

  constructor(
    private location: Location,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Later fetch profile data from a service
  }

  goBack(): void {
    this.location.back();
  }

  editProfile(): void {
    this.router.navigate(['/profile-creation']);
  }
}
