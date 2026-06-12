#include "HotkeyDialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QAction>
#include <QKeySequenceEdit>
#include <QPushButton>

HotkeyDialog::HotkeyDialog(QList<QAction*> actions, QWidget* parent)
    : QDialog(parent), m_actions(actions)
{
    setWindowTitle("Hotkey Settings");
    resize(300, 250);

    QVBoxLayout* mainLayout = new QVBoxLayout(this);

    for (QAction* action : actions)
    {
        QHBoxLayout* rowLayout = new QHBoxLayout();
        QLabel* label = new QLabel(action->text().remove('&'), this);
        QKeySequenceEdit* edit = new QKeySequenceEdit(action->shortcut(), this);
        
        rowLayout->addWidget(label);
        rowLayout->addWidget(edit);
        mainLayout->addLayout(rowLayout);
        
        m_edits.append(edit);
    }

    QHBoxLayout* btnLayout = new QHBoxLayout();
    QPushButton* saveBtn = new QPushButton("Save", this);
    QPushButton* cancelBtn = new QPushButton("Cancel", this);
    
    connect(saveBtn, &QPushButton::clicked, this, &QDialog::accept);
    connect(cancelBtn, &QPushButton::clicked, this, &QDialog::reject);
    
    btnLayout->addStretch();
    btnLayout->addWidget(saveBtn);
    btnLayout->addWidget(cancelBtn);
    
    mainLayout->addLayout(btnLayout);
}

QMap<QAction*, QKeySequence> HotkeyDialog::getNewShortcuts() const
{
    QMap<QAction*, QKeySequence> result;
    for (int i = 0; i < m_actions.size(); ++i)
    {
        result[m_actions[i]] = m_edits[i]->keySequence();
    }
    return result;
}
