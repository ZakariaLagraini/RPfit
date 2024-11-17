import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Location } from '@angular/common';
import { Chart, ChartConfiguration } from 'chart.js/auto';
import { ScheduleModalComponent } from '../components/schedule-modal/schedule-modal.component';

interface WeeklyGoal {
  title: string;
  progress: number;
  progressColor: string;
}

interface RecentActivity {
  title: string;
  description: string;
  time: string;
  icon: string;
  iconColor: string;
  bgColor: string;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule, ScheduleModalComponent],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {
  weeklyGoals: WeeklyGoal[] = [
    {
      title: 'Workout Sessions',
      progress: 75,
      progressColor: 'bg-red-500'
    },
    {
      title: 'Calorie Target',
      progress: 60,
      progressColor: 'bg-blue-500'
    },
    {
      title: 'Water Intake',
      progress: 85,
      progressColor: 'bg-green-500'
    },
    {
      title: 'Sleep Goal',
      progress: 65,
      progressColor: 'bg-purple-500'
    }
  ];

  recentActivities: RecentActivity[] = [
    {
      title: 'Completed Chest Workout',
      description: 'Finished 4 sets of bench press and 3 sets of push-ups',
      time: '2h ago',
      icon: 'fas fa-dumbbell',
      iconColor: 'text-red-500',
      bgColor: 'bg-red-100'
    },
    {
      title: 'Logged Nutrition',
      description: 'Added breakfast and lunch - 1,200 calories total',
      time: '4h ago',
      icon: 'fas fa-apple-alt',
      iconColor: 'text-green-500',
      bgColor: 'bg-green-100'
    },
    {
      title: 'New Personal Best',
      description: 'Deadlift: 225lbs for 5 reps',
      time: '1d ago',
      icon: 'fas fa-medal',
      iconColor: 'text-yellow-500',
      bgColor: 'bg-yellow-100'
    }
  ];

  // Using the same chart colors from ProgressComponent
  private chartColors = {
    primary: '#4F46E5',    
    secondary: '#06B6D4',  
    tertiary: '#8B5CF6',   
    success: '#059669',    
    warning: '#F59E0B',    
    info: '#3B82F6',       
    accent: '#EC4899'
  };

  isScheduleModalOpen = false;

  constructor(private location: Location) {}

  ngOnInit(): void {
    this.initializeCharts();
  }

  goBack(): void {
    this.location.back();
  }

  private initializeCharts(): void {
    // Initialize your dashboard charts here
  }

  openScheduleModal() {
    this.isScheduleModalOpen = true;
  }

  handleScheduleSession(session: any) {
    console.log('Scheduled session:', session);
    // Implement your scheduling logic here
    this.isScheduleModalOpen = false;
  }
}
