import { Component, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { Location } from '@angular/common';

@Component({
  selector: 'app-profile-creation',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, RouterModule],
  templateUrl: './profile-creation.component.html',
  styleUrls: ['./profile-creation.component.css']
})
export class ProfileCreationComponent implements OnDestroy {
  profilePicture: File | null = null;
  weightUnit: 'kg' | 'lbs' = 'kg';
  heightUnit: 'cm' | 'ft' = 'cm';
  profileImageUrl: string | null = null;

  formData = {
    firstName: '',
    lastName: '',
    age: null,
    weight: null,
    height: null,
    fitnessGoal: '',
    experienceLevel: ''
  };

  constructor(private router: Router, private location: Location) {}

  onFileChange(event: any): void {
    const file = event.target.files?.[0];
    if (file) {
      this.profilePicture = file;
      // Only create URL if file exists
      this.profileImageUrl = URL.createObjectURL(file);
    }
  }

  getProfileImageUrl(): string {
    return this.profileImageUrl || 'assets/default-profile.png';
  }

  saveProfile(): void {
    console.log('Profile data:', this.formData);
    
    // Prevent default form submission
    // Prevent.preventDefault();
    
    switch (this.formData.fitnessGoal) {
      case 'weightLoss':
        this.router.navigate(['/exercises/weight-loss']);
        break;
      case 'muscleGain':
        this.router.navigate(['/exercises/muscle-gain']);
        break;
      case 'endurance':
        this.router.navigate(['/exercises/maintenance']);
        break;
      case 'flexibility':
        this.router.navigate(['/exercises/flexibility']);
        break;
      default:
        this.router.navigate(['/exercises']);
    }
  }

  goBack(): void {
    this.location.back();
  }

  ngOnDestroy() {
    if (this.profileImageUrl) {
      URL.revokeObjectURL(this.profileImageUrl);
    }
  }
}
