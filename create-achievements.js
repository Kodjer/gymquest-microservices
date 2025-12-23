// create-achievements.js
const SUPABASE_URL = 'https://qdjyzrhnbrxugalcqubg.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkanl6cmhuYnJ4dWdhbGNxdWJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMzQ3NDIsImV4cCI6MjA4MDYxMDc0Mn0.BU6M61AMh7p5l6JN9IdERrJldYJDWVgS3NlqHtrXEqs';

const achievements = [
  { id: 'ffffffff-1111-1111-1111-111111111111', name: 'First Step', description: 'Complete your first quest' },
  { id: 'ffffffff-2222-2222-2222-222222222222', name: 'Level 5 Master', description: 'Reach level 5' },
  { id: 'ffffffff-3333-3333-3333-333333333333', name: 'Quest Hunter', description: 'Complete 10 quests' }
];

async function createData() {
  console.log('Creating achievements...');
  
  for (const ach of achievements) {
    try {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/achievements`, {
        method: 'POST',
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Content-Type': 'application/json',
          'Prefer': 'return=representation'
        },
        body: JSON.stringify([ach])
      });
      console.log(`Achievement ${ach.name}: ${res.status}`);
    } catch (e) {
      console.log(`Achievement ${ach.name}: exists`);
    }
  }
  
  console.log('\nLinking to user...');
  for (const ach of achievements) {
    try {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/user_achievements`, {
        method: 'POST',
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Content-Type': 'application/json',
          'Prefer': 'return=representation'
        },
        body: JSON.stringify([{ user_id: 'demo-user-123', achievement_id: ach.id }])
      });
      console.log(`  Linked ${ach.name}: ${res.status}`);
    } catch (e) {
      console.log(`  ${ach.name}: exists`);
    }
  }
  
  console.log('\nDone!');
}

createData();
