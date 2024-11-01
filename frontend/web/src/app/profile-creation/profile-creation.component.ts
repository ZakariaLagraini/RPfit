import { Component, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-profile-creation',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
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
    // Add your save logic here
  }

  ngOnDestroy() {
    if (this.profileImageUrl) {
      URL.revokeObjectURL(this.profileImageUrl);
    }
  }
}
