import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('''                child: const Text('OU?O, O UU.UU.Oc', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}''', '''                child: const Text('O-U?O, O U,U.UU.Oc', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      )),
    );
  }
}''')

content = content.replace('''            ],
          ),
        ),
      ),
    );
  }
}

class _TaskDetailsSheet extends StatefulWidget {''', '''            ],
          ),
        ),
      )),
    );
  }
}

class _TaskDetailsSheet extends StatefulWidget {''')

content = content.replace('''                        onPressed: _deleteTask,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ... skipping to the end of TaskDetailsSheet ...''', '')

# Just replace the end of _TaskDetailsSheet
content = content.replace('''                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}''', '''                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}''')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed parens 2")
