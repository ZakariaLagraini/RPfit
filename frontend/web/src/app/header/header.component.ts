import { Component, ElementRef, HostListener, ViewChild } from '@angular/core';
import { RouterModule, Router } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [RouterModule, CommonModule],
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent {
  @ViewChild('dropdown') dropdownRef!: ElementRef;
  isDropdownOpen = false;
  isAuthenticated = false;

  constructor(private router: Router) {
    this.checkAuthStatus();
  }

  checkAuthStatus(): void {
    const hasProfile = localStorage.getItem('userProfile');
    this.isAuthenticated = !!hasProfile;
  }

  goToSignIn(): void {
    this.router.navigate(['/sign-in']);
  }

  toggleDropdown(): void {
    this.isDropdownOpen = !this.isDropdownOpen;
  }

  signOut(): void {
    localStorage.removeItem('userProfile');
    this.isAuthenticated = false;
    this.isDropdownOpen = false;
    this.router.navigate(['/']);
  }

  @HostListener('document:click', ['$event'])
  onDocumentClick(event: MouseEvent) {
    if (!this.dropdownRef.nativeElement.contains(event.target)) {
      this.isDropdownOpen = false;
    }
  }
}
