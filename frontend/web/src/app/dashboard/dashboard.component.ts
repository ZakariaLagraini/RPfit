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
    this.createWorkoutProgressChart();
    this.createBodyMetricsChart();
  }

  private createWorkoutProgressChart(): void {
    const ctx = document.getElementById('workoutChart') as HTMLCanvasElement;
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: 'Workouts',
          data: [3, 4, 2, 5, 3, 4, 2],
          backgroundColor: this.chartColors.primary,
          borderRadius: 6
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            display: false
          },
          title: {
            display: false
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            grid: {
              display: false
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      }
    });
  }

  private createBodyMetricsChart(): void {
    const ctx = document.getElementById('metricsChart') as HTMLCanvasElement;
    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
        datasets: [
          {
            label: 'Weight (lbs)',
            data: [185, 183, 181, 179],
            borderColor: this.chartColors.primary,
            tension: 0.3,
            fill: true,
            backgroundColor: 'rgba(79, 70, 229, 0.1)'
          },
          {
            label: 'Body Fat %',
            data: [22, 21, 20.5, 19.8],
            borderColor: this.chartColors.secondary,
            tension: 0.3,
            fill: true,
            backgroundColor: 'rgba(6, 182, 212, 0.1)'
          },
          {
            label: 'Muscle Mass (lbs)',
            data: [142, 143, 144, 145],
            borderColor: this.chartColors.success,
            tension: 0.3,
            fill: true,
            backgroundColor: 'rgba(5, 150, 105, 0.1)'
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              usePointStyle: true,
              padding: 15
            }
          }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280' }
          },
          y: {
            grid: { color: 'rgba(107, 114, 128, 0.1)' },
            ticks: { color: '#6B7280' }
          }
        }
      }
    };
    new Chart(ctx, config);
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
