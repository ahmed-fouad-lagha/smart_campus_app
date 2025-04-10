# Smart Campus Insights

A unified university data application for Smart Campus Insights.

## Features

### Authentication
- User registration and login
- Secure password storage
- Session management

### Dashboard
- Overview of academic performance
- Course attendance visualization
- Enrollment trends analysis
- Event popularity metrics

### Courses
- List of enrolled courses
- Course details and schedule
- Attendance analytics
- Performance tracking

### Events
- Campus events calendar
- Event details and location
- Popularity metrics
- RSVP functionality

### Data Visualization
- Interactive charts and graphs
- Attendance tracking
- Enrollment predictions
- Event popularity analysis

### AI/ML Integration
- Personalized course recommendations
- GPA prediction and academic performance forecasting
- Career path analysis and suggestions
- Feedback sentiment analysis
- Study habit improvement suggestions

## Getting Started

### Prerequisites
- Flutter SDK (2.19.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository
   \`\`\`bash
   git clone https://github.com/yourusername/smart-campus-insights.git
   \`\`\`

2. Navigate to the project directory
   \`\`\`bash
   cd smart-campus-insights
   \`\`\`

3. Install dependencies
   \`\`\`bash
   flutter pub get
   \`\`\`

4. Run the app
   \`\`\`bash
   flutter run
   \`\`\`

## Project Structure

- `lib/main.dart` - Entry point
- `lib/app.dart` - App configuration
- `lib/config/` - Routes and themes
- `lib/models/` - Data models
- `lib/screens/` - UI screens
- `lib/services/` - API, auth, storage, and ML services
- `lib/utils/` - Utility functions
- `lib/widgets/` - Reusable widgets

## Dependencies

- `go_router` - Navigation
- `provider` - State management
- `shared_preferences` - Local storage
- `http` - API requests
- `fl_chart` - Data visualization
- `percent_indicator` - Progress indicators
- `shimmer` - Loading effects
- `intl` - Date formatting
- `crypto` - Password hashing

## AI/ML Features

### Course Recommendations
The app uses a recommendation system to suggest courses based on:
- Previously taken courses
- Academic interests
- Career goals
- Course popularity and ratings

### GPA Prediction
Predicts future academic performance using:
- Current GPA
- Course difficulty
- Study habits
- Historical performance patterns

### Career Path Analysis
Analyzes potential career paths based on:
- Academic performance
- Course selection
- Skills assessment
- Industry trends

### Feedback Sentiment Analysis
Analyzes the sentiment of course feedback to:
- Identify positive and negative aspects
- Extract key themes and topics
- Provide actionable insights

## Future Enhancements

1. **Web Scraping**
   - University website data extraction
   - Automated data updates
   - Scheduled synchronization

2. **Offline Mode**
   - Local database
   - Background sync
   - Offline-first architecture

3. **User Experience**
   - Animations and transitions
   - Dark mode
   - Accessibility features

## License

This project is licensed under the MIT License - see the LICENSE file for details.
